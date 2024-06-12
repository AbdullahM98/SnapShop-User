import Foundation
import FirebaseFirestore
import Combine


class FirestoreManager {
    let db: Firestore
    var collectionRef: CollectionReference?
    
    init() {
        db = Firestore.firestore()
        collectionRef = db.collection("Favorite_Products")
    }
    
    func getAllFavProductsRemote(userId: String) -> AnyPublisher<[ProductEntity], Error> {
        return Future { promise in
            self.collectionRef?.whereField("userId", isEqualTo: userId).getDocuments { snapShot, error in
                if let error = error {
                    promise(.failure(error))
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
