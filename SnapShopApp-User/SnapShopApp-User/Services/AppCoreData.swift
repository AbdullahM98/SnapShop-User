//
//  AppCoreData.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 05/06/2024.
//

import Foundation
import CoreData
class AppCoreData{
   static let shared = AppCoreData()
   let entityName = "Fav_Product"
    var products :[ProductEntity] = []
    var container:NSPersistentContainer
   private init() {
        self.container = NSPersistentContainer(name: "AppModel")
        container.loadPersistentStores(completionHandler: {
            (description,error) in
            if let error = error {
                print("Error loading CoreData\(error)")
            }
        })
    }
    
    var context: NSManagedObjectContext {
          return container.viewContext
      }
      
    
    func getAllProducts(by userId: String) -> [ProductEntity] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let productsEntities = try context.fetch(request)
            var products :[ProductEntity] = []
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
                else{
                    return []
                }
                let product = ProductEntity(userId: userId, product_id: id, variant_Id: variant_id, title: title, body_html: body_html, vendor: vendor, product_type: product_type, inventory_quantity: inventory_quantity, tags: tags, price: price, images: [images])
                products.append(product)
            }
            return products
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
    
    func addFavProduct(favProduct:ProductEntity) {
        if products.count <= 4 {
            guard let productEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                print("Failed to create entity description.")
                return
            }

            let newProduct = NSManagedObject(entity: productEntity, insertInto: context)
            
            newProduct.setValue(favProduct.userId, forKey: "userId")
            newProduct.setValue(favProduct.product_id, forKey: "id")
            newProduct.setValue(favProduct.title, forKey: "title")
            newProduct.setValue(favProduct.vendor, forKey: "vendor")
            newProduct.setValue(favProduct.variant_Id, forKey: "variant_Id")
            newProduct.setValue(favProduct.tags, forKey: "tags")
            newProduct.setValue(favProduct.body_html, forKey: "body_html")
            newProduct.setValue(favProduct.inventory_quantity, forKey: "inventory_quantity")
            newProduct.setValue(favProduct.price, forKey: "price")
            newProduct.setValue(favProduct.product_type, forKey: "product_type")
            newProduct.setValue(favProduct.images?[0], forKey: "images")
            do {
                try context.save()
                print("Customer inserted successfully.")
            } catch {
                print("Failed inserting customer: \(error)")
            }
        }else{
            print("UserAlreadyHasFour")
        }
    }
    
    
    func deleteProductById(id: String) {
        // Fetch the product by ID
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
       
        
        do {
            let products = try context.fetch(request)
            
            // Check if the product exists
            if !products.isEmpty {
                let productToDelete = products.first
                
                
                
                // Delete the product
                context.delete(productToDelete!)
                
                // Save changes
                do {
                    try context.save()
                    print("Product and variants deleted successfully.")
                } catch {
                    print("Failed deleting product and variants: \(error)")
                }
            } else {
                print("No product found with the given ID.")
            }
        } catch {
            print("Failed fetching product: \(error)")
        }
    }

   }


