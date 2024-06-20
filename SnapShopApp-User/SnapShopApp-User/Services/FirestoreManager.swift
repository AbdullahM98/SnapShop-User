import Foundation
import FirebaseFirestore
import Combine

// MARK: - FirestoreManager Class

class FirestoreManager {
    // MARK: - Properties
    
    let db: Firestore
    var collectionRef: CollectionReference?
    
    // MARK: - Initialization
    
    init() {
        db = Firestore.firestore()
        collectionRef = db.collection("Favorite_Products")
    }
    
    // MARK: - Public Methods
    
    // Retrieve all favorite products for a user from Firestore
    func getAllFavProductsRemote(userId: String) -> AnyPublisher<[ProductEntity], Error> {
        return Future { promise in
            self.collectionRef?.whereField("userId", isEqualTo: userId).getDocuments { snapShot, error in
                if let error = error {
                    // Check if the error is related to network connectivity
                    if let errCode = (error as NSError).userInfo[NSUnderlyingErrorKey] as? Int, errCode == -1009 {
                        promise(.failure(NetworkError.disconnected))
                        SnackBarHelper.showSnackBar(isConnected: false) // Optional: Handle network error UI feedback
                    } else {
                        promise(.failure(error))
                    }
                } else if let snapShot = snapShot {
                    let products = snapShot.documents.compactMap { document -> ProductEntity? in
                        return ProductEntity(
                            userId: document["userId"] as? String,
                            product_id: document["id"] as? String,
                            variant_Id: document["variant_id"] as? String,
                            title: document["title"] as? String,
                            body_html: document["description"] as? String,
                            vendor: document["vendor"] as? String,
                            product_type: document["product_type"] as? String,
                            inventory_quantity: document["quantity"] as? String,
                            tags: document["tags"] as? String,
                            price: document["price"] as? String,
                            images: document["images"] as? [String],
                            isFav: document["isFav"] as? Bool
                        )
                    }
                    promise(.success(products))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Add a product to the favorites collection in Firestore
    func addProductToFavRemote(product: ProductEntity) -> AnyPublisher<Void, Error> {
        return Future { promise in
            let data: [String: Any] = [
                "userId": product.userId ?? "",
                "id": product.product_id ?? "",
                "variant_id": product.variant_Id ?? "",
                "title": product.title ?? "",
                "description": product.body_html ?? "",
                "vendor": product.vendor ?? "",
                "product_type": product.product_type ?? "",
                "quantity": product.inventory_quantity ?? "",
                "tags": product.tags ?? "",
                "price": product.price ?? "",
                "images": product.images ?? [],
                "isFav": product.isFav ?? false
            ]
            
            self.collectionRef?.addDocument(data: data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Remove a product from the favorites collection in Firestore by product ID
    func removeProductFromFavRemote(productId: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.collectionRef?.whereField("id", isEqualTo: productId).getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                    for document in querySnapshot.documents {
                        document.reference.delete { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - NetworkError Enumeration

enum NetworkError: Error {
    case disconnected
}
