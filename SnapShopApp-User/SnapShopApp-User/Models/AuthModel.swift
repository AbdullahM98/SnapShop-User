//
//  File.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation

struct LoginRequest {
    var email : String
    var password : String
}

struct authResponse: Codable {
    let customer: CustomerAuthResponse
}

struct SignInResponse: Codable {
    let customers: [CustomerAuthResponse]
}
struct CustomerAuthResponse: Codable {
    let id: Int
    let email: String
}
