//
//  AppCoreData.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 05/06/2024.
//

import Foundation
import CoreData


protocol CoreDbService {
    func getAllProducts(by userId: String) -> [ProductEntity]
    func addFavProduct(favProduct: ProductEntity)
    func deleteProduct(product: ProductEntity)
}
// MARK: - AppCoreData Class

class AppCoreData : CoreDbService {
    // MARK: - Singleton Instance
    
    static let shared = AppCoreData()
    
    // MARK: - Properties
    
    private let entityName = "Fav_Product"
    private var products: [ProductEntity] = []
    private var container: NSPersistentContainer
    
    // MARK: - Initialization
    
    private init() {
        self.container = NSPersistentContainer(name: "AppModel")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                // Error handling can be improved by logging or showing alerts
                print("Error loading CoreData: \(error)")
            }
        })
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - Core Data Operations
    
    func getAllProducts(by userId: String) -> [ProductEntity] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "userId == %@", userId)
        self.products = []
        
        do {
            let productsEntities = try context.fetch(request)
            for productEntity in productsEntities {
                guard let userId = productEntity.value(forKey: "userId") as? String,
                      let vendor = productEntity.value(forKey: "vendor") as? String,
                      let title = productEntity.value(forKey: "title") as? String,
                      let tags = productEntity.value(forKey: "tags") as? String,
                      let product_type = productEntity.value(forKey: "product_type") as? String,
                      let price = productEntity.value(forKey: "price") as? String,
                      let inventory_quantity = productEntity.value(forKey: "inventory_quantity") as? String,
                      let images = productEntity.value(forKey: "images") as? String,
                      let id = productEntity.value(forKey: "id") as? String,
                      let variant_id = productEntity.value(forKey: "variant_id") as? String,
                      let body_html = productEntity.value(forKey: "body_html") as? String
                else {
                    return []
                }
                let product = ProductEntity(
                    userId: userId,
                    product_id: id,
                    variant_Id: variant_id,
                    title: title,
                    body_html: body_html,
                    vendor: vendor,
                    product_type: product_type,
                    inventory_quantity: inventory_quantity,
                    tags: tags,
                    price: price,
                    images: [images]
                )
                products.append(product)
            }
            return products
        } catch {
            // Error handling can be improved by logging or showing alerts
            print("Failed to fetch products: \(error)")
            return []
        }
    }
    
    func checkProductIfFav(productId: String) -> Bool {
        if productId != "0" {
            return products.contains(where: { $0.product_id == productId })
        }
        return false
    }
    
    func addFavProduct(favProduct: ProductEntity) {
        guard let productEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            // Error handling can be improved by logging or showing alerts
            print("Failed to create entity description.")
            return
        }
        
        let newProduct = NSManagedObject(entity: productEntity, insertInto: context)
        
        newProduct.setValue(favProduct.userId, forKey: "userId")
        newProduct.setValue(favProduct.product_id, forKey: "id")
        newProduct.setValue(favProduct.title, forKey: "title")
        newProduct.setValue(favProduct.vendor, forKey: "vendor")
        newProduct.setValue(favProduct.variant_Id, forKey: "variant_id")
        newProduct.setValue(favProduct.tags, forKey: "tags")
        newProduct.setValue(favProduct.body_html, forKey: "body_html")
        newProduct.setValue(favProduct.inventory_quantity, forKey: "inventory_quantity")
        newProduct.setValue(favProduct.price, forKey: "price")
        newProduct.setValue(favProduct.product_type, forKey: "product_type")
        newProduct.setValue(favProduct.images?.first, forKey: "images")
        
        do {
            try context.save()
            self.products = self.getAllProducts(by: favProduct.userId!)
        } catch {
            // Error handling can be improved by logging or showing alerts
            print("Failed inserting product: \(error)")
        }
    }
    
    func isProductInFavorites(product: ProductEntity) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.product_id ?? "0")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            // Error handling can be improved by logging or showing alerts
            print("Failed to fetch product: \(error)")
            return false
        }
    }
    
    func deleteProduct(product: ProductEntity) {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "userId == %@", product.userId ?? "0"),
            NSPredicate(format: "id == %@", product.product_id ?? "0")
        ])
        
        do {
            let products = try context.fetch(request)
            if let productToDelete = products.first {
                context.delete(productToDelete)
                
                do {
                    try context.save()
                    if let index = self.products.firstIndex(where: { $0.product_id == product.product_id }) {
                        self.products.remove(at: index)
                    }
                } catch {
                    // Error handling can be improved by logging or showing alerts
                    print("Failed deleting product: \(error)")
                }
            } else {
                // Error handling can be improved by logging or showing alerts
                print("No product found with the given ID.")
            }
        } catch {
            // Error handling can be improved by logging or showing alerts
            print("Failed fetching product: \(error)")
        }
    }
}
