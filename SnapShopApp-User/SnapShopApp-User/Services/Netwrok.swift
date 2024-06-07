//
//  Netwrok.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation
import Combine

protocol NetworkService {
    func postCustomer(_ customer: Customer) -> AnyPublisher<authResponse, Error> }

enum ApiError: Error {
    case invalidUrl
    case invalidResponseCode(Int)
    case unknown
}


class Network :NetworkService{
    static let shared = Network()
    
    private init() {}
    
    
    func request<T: Decodable>(_ url: String,
                                method: String,
                                responseType: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            print("url is \(url)")
            completion(.failure(ApiError.invalidUrl))
            return
        }
        print("url is \(url)")
        
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
    
    func postCustomer(_ customer: Customer) -> AnyPublisher<authResponse, Error> {
        guard let url = URL(string: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers.json") else {
            return Fail(error: NSError(domain: "Invalid Url", code: -1, userInfo: nil)).eraseToAnyPublisher()
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
       
        request.addValue(Support.password, forHTTPHeaderField: Support.apiToken)

           let customerWrapper = CustomerRequest(customer: customer)
        print("\(customer.email!)")
        print("\(customer.password!)")
        print("\(customer.phone!)")
        print("\(customer.addresses![0].address1!)")
        print("\(customer.addresses![0].phone!)")
        
        // Encode the customer data using JSONEncoder
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(customerWrapper) {
            request.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding:.utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert JSON data to string")
                }
        } else {
            print("Failed to encode JSON")
        }

           
           return URLSession.shared.dataTaskPublisher(for: request)
               .tryMap { (data, response) -> Data in
                   if let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) {
                       return data
                   } else {
                       let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                       print("Request failed with status code: \(statusCode)")
                       throw NSError(domain: "Request failed with status code: \(statusCode)", code: -1, userInfo: nil)
                   }
               }
               .decode(type: authResponse.self, decoder: JSONDecoder())
               .mapError { error -> Error in
                   if let decodingError = error as? DecodingError {
                       print("Decoding error: \(decodingError)")
                       print("Decoding error: \(error)")
                       return decodingError
                   } else {
                       print("Unknown error: \(error)")
                       return error
                   }
               }
               .eraseToAnyPublisher()
       }
    
    
    func getItemByID<T: Decodable>(_ itemID: String, type: T.Type, endpoint: String) -> AnyPublisher<T, Error> {
                let urlString = "\(Support.baseUrl)/\(endpoint)/\(itemID).json"
        print("url is \(urlString)")
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
                            print("Decoding error: \(decodingError)")
                            return decodingError
                        } else {
                            print("Unknown error: \(error)")
                            return error
                        }
                    }
                    .eraseToAnyPublisher()
            }
   }

