//
//  MockCoreData.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import Foundation
@testable import SnapShopApp_User
class MockAppCoreData : CoreDbService {
    var products: [ProductEntity] = []
    var isProductInFavoritesReturnValue = false
//    var userId = "7294848041139"
     func getAllProducts(by userId: String) -> [ProductEntity] {
        return products
    }
    
     func addFavProduct(favProduct: ProductEntity) {
        products.append(favProduct)
    }
    
     func deleteProduct(product: ProductEntity) {
        products.removeAll { $0.product_id == product.product_id }
    }
      
       func isProductInFavorites(product: ProductEntity) -> Bool {
          return isProductInFavoritesReturnValue
      }
}

class MockUserDefaultsManager {

    var getUserIdResult: Int?
    var hasDraft  = false
    var userDraftId: Int?

     func getUserId(key: String) -> Int? {
        return getUserIdResult
    }
}
