//
//  MockFireStoreManager.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import Foundation
import Combine 
@testable import SnapShopApp_User
class MockFirestoreManager: FirestoreManager {
    
    var fetchFavProductsResult: Result<[ProductEntity], Error> = .success([])
    var addProductToFavResult: Result<Void, Error> = .success(())
    var removeProductFromFavResult: Result<Void, Error> = .success(())

    override func getAllFavProductsRemote(userId: String) -> AnyPublisher<[ProductEntity], Error> {
        return fetchFavProductsResult.publisher.eraseToAnyPublisher()
    }
    
    override func addProductToFavRemote(product: ProductEntity) -> AnyPublisher<Void, Error> {
        return addProductToFavResult.publisher.eraseToAnyPublisher()
    }
    
    override func removeProductFromFavRemote(productId: String) -> AnyPublisher<Void, Error> {
        return removeProductFromFavResult.publisher.eraseToAnyPublisher()
    }
}
