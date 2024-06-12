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
      
    
//
//    func fetchAllProducts() -> [ProductEntity] {
//      
//      //  let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
//
//        do {
//            let products = try context.fetch(fetchRequest)
//            return products
//        } catch {
//            print("Failed to fetch products: \(error)")
//            return []
//        }
//    }
//    func createProductEntity(product: ProductEntity) {
//      
//        let productEntity = ProductEntity(context: context)
//
//        productEntity.userId = product.userId
//        productEntity.id = product.id
//        productEntity.variant_Id = product.variant_Id
//        productEntity.title = product.title
//        productEntity.body_html = product.body_html
//        productEntity.vendor = product.vendor
//        productEntity.product_type = product.product_type
//        productEntity.inventory_quantity = product.inventory_quantity
//        productEntity.tags = product.tags
//        productEntity.price = product.price
//        productEntity.image = product.images![0]
//        productEntity.isFav = product.isFav ?? false
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to create product: \(error)")
//        }
//    }
//    func deleteProduct(byID id: String) {
//        
//        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//
//        do {
//            let products = try context.fetch(fetchRequest)
//            if let productToDelete = products.first {
//                context.delete(productToDelete)
//                try context.save()
//            }
//        } catch {
//            print("Failed to delete product: \(error)")
//        }
//    }
   }


