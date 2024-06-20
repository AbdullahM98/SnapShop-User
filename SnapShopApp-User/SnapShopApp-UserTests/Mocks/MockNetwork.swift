//
//  MockNetwork.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//
import Foundation
import Combine
@testable import SnapShopApp_User

class MockNetworkService: NetworkService {
    
    var getItemByIDResult: AnyPublisher<ProductResponse, Error> = Just(ProductResponse(product: nil))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    
    func postCustomer(_ customer: Customer) -> AnyPublisher<authResponse, Error> {
        // Simulate a successful response
        let dummyResponse = authResponse(customer: CustomerAuthResponse(id: 2, email: "Done"))
        return Just(dummyResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func request<T>(_ url: String, method: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        // Simulate a successful response
        let dummyData = Data() // Replace with appropriate dummy data
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: dummyData)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(ApiError.unknown))
        }
    }
    
    func postData<T>( object: T, to url: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        // Simulate a successful response
        completion(.success(object))
    }
    
    func updateData<T>( object: T, to url: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        // Simulate a successful response
        completion(.success(object))
    }
    
    func deleteObject(with url: String, completion: @escaping (Error?) -> Void) {
        // Simulate a successful response
        completion(nil)
    }
    
    func getItemByID<T>(_ itemID: String, type: T.Type, endpoint: String) -> AnyPublisher<T, Error> where T : Decodable {
        // Simulate a successful response
        let dummyResponse = Data() // Replace with appropriate dummy data
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: dummyResponse)
            return Just(decodedResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ApiError.unknown).eraseToAnyPublisher()
        }
    }
}
