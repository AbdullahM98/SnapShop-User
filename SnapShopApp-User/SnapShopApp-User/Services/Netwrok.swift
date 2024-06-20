//
//  Netwrok.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation
import Combine

// MARK: - NetworkService Protocol

protocol NetworkService {
    func postCustomer(_ customer: Customer) -> AnyPublisher<authResponse, Error>
    func request<T: Decodable>(_ url: String,
                               method: String,
                               responseType: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void)
    func postData<T: Codable>(object: T, to url: String, completion: @escaping (Result<T, Error>) -> Void)
    func updateData<T: Codable>(object: T, to url: String, completion: @escaping (Result<T, Error>) -> Void)
    func deleteObject(with url: String, completion: @escaping (Error?) -> Void)
    func getItemByID<T: Decodable>(_ itemID: String, type: T.Type, endpoint: String) -> AnyPublisher<T, Error>
}

// MARK: - ApiError Enumeration

enum ApiError: Error {
    case invalidUrl
    case invalidResponseCode(Int)
    case unknown
}

// MARK: - Network Class

class Network: NetworkService {
    static let shared = Network()
    
    private init() {}
    
    // MARK: - Request Method
    
    func request<T: Decodable>(_ url: String,
                               method: String,
                               responseType: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(.failure(error ?? ApiError.unknown))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(ApiError.invalidResponseCode(httpResponse.statusCode)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Post Data Method
    
    func postData<T: Codable>(object: T, to url: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(object)
            guard let url = URL(string: url) else {
                completion(.failure(ApiError.invalidUrl))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(Support.password, forHTTPHeaderField: Support.apiToken)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(error ?? ApiError.unknown))
                    return
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    completion(.failure(ApiError.invalidResponseCode(httpResponse.statusCode)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Update Data Method
    
    func updateData<T: Codable>(object: T, to url: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(object)
            guard let url = URL(string: url) else {
                completion(.failure(ApiError.invalidUrl))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(Support.password, forHTTPHeaderField: Support.apiToken)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(error ?? ApiError.unknown))
                    return
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    completion(.failure(ApiError.invalidResponseCode(httpResponse.statusCode)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Delete Object Method
    
    func deleteObject(with url: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: url) else {
            completion(ApiError.invalidUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                completion(error)
                return
            }

            completion(nil)
        }

        task.resume()
    }
    
    // MARK: - Post Customer Method
    
    func postCustomer(_ customer: Customer) -> AnyPublisher<authResponse, Error> {
        guard let url = URL(string: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers.json") else {
            return Fail(error: ApiError.invalidUrl).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Support.password, forHTTPHeaderField: Support.apiToken)

        let customerWrapper = CustomerRequest(customer: customer)
  
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(customerWrapper) else {
            return Fail(error: ApiError.unknown).eraseToAnyPublisher()
        }
        
        request.httpBody = jsonData

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw ApiError.invalidResponseCode(statusCode)
                }
            }
            .decode(type: authResponse.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    return decodingError
                } else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Get Item By ID Method
    
    func getItemByID<T: Decodable>(_ itemID: String, type: T.Type, endpoint: String) -> AnyPublisher<T, Error> {
        let urlString = "\(Support.baseUrl)/\(endpoint)/\(itemID).json"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    return decodingError
                } else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}
