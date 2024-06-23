//
//  MockFireStoreManager.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import Foundation
import Combine 
@testable import SnapShopApp_User
class MockFirestoreManager: FirestoreService {
    var shouldSucceed = true
    var products: [ProductEntity] = []
    
    var fetchFavProductsResult: Result<[ProductEntity], Error> = .success([])
    var addProductToFavResult: Result<Void, Error> = .success(())
    var removeProductFromFavResult: Result<Void, Error> = .success(())

     func getAllFavProductsRemote(userId: String) -> AnyPublisher<[ProductEntity], Error> {
        return fetchFavProductsResult.publisher.eraseToAnyPublisher()
    }
    
     func addProductToFavRemote(product: ProductEntity) -> AnyPublisher<Void, Error> {
        return addProductToFavResult.publisher.eraseToAnyPublisher()
    }
    
     func removeProductFromFavRemote(productId: String) -> AnyPublisher<Void, Error> {
        return removeProductFromFavResult.publisher.eraseToAnyPublisher()
    }
}
