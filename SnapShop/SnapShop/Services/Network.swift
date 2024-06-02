//
//  Network.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 25/05/2024.
//

import Foundation

class Network {
    static let shared = Network()
    
    private init() {}
    
    func request<T: Decodable>(_ url: String,
                                method: String,
                                responseType: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
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
}

enum ApiError: Error {
    case invalidUrl
    case invalidResponseCode(Int)
    case unknown
}
