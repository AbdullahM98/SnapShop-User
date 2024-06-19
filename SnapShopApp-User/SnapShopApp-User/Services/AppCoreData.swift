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
                else{
                    return []
                }
                let product = ProductEntity(userId: userId, product_id: id, variant_Id: variant_id, title: title, body_html: body_html, vendor: vendor, product_type: product_type, inventory_quantity: inventory_quantity, tags: tags, price: price, images: [images])
                print("userId in fetch is \(product.userId!)")
                print("Id in fetch is \(product.product_id!)")
                products.append(product)
            }
            return products
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
    
    func checkProductIfFav(productId:String)-> Bool{
        print("check from CD")
        if (productId != "0"){
            print("not 0 ")
            var isFavorite = false
            for product in products {
                print("inside products")
                if product.product_id == productId {
                    print("id \(product.product_id)")
                    isFavorite = true
                }
            }
            return isFavorite
        }else{
            return false
        }
    }
    
    func addFavProduct(favProduct:ProductEntity) {
       
            guard let productEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
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
            newProduct.setValue(favProduct.images?[0], forKey: "images")
            do {
                try context.save()
                print("Product inserted successfully.")
                self.products = self.getAllProducts(by: favProduct.userId!)
            } catch {
                print("Failed inserting product: \(error)")
            }
       
    }
    
    func isProductInFavorites(product: ProductEntity) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.product_id ?? "0")

        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Failed to fetch product: \(error)")
            return false
        }
    }
    func deleteProduct(product:ProductEntity) {
        // Fetch the product by ID
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        print("userId in delete is \(product.userId!)")
        print("Id in delete is \(product.product_id!)")
        request.predicate = NSPredicate(format: "userId == %@", product.userId ?? "0")
        request.predicate = NSPredicate(format: "id == %@", product.product_id ?? "0")
     
        
        do {
            let products = try context.fetch(request)
            
            // Check if the product exists
            if !products.isEmpty {
                let productToDelete = products.first
                try context.delete(productToDelete!)

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
        if let index = products.firstIndex(where: { $0.product_id == product.product_id }) {
            
           products.remove(at: index)
        }
    }

   }


