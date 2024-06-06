//
//  CustomerModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//
import Foundation

// CustomerRequest struct
struct CustomerRequest: Codable {
    let customer: Customer
}

// Customer struct
struct Customer: Codable {
    var password_confirmation: String? = ""
    let phone: String?
    let password: String?
    let last_name: String
    var send_email_welcome: Bool? = false
    var verified_email: Bool? = true
    let addresses: [Address]?
    let email: String?
    let first_name: String?
}


struct Address: Codable {
    let phone: String?
    let country: String?
    var province: String? = ""
    var zip: String? = ""
    let address1: String?
    let first_name: String?
    let last_name: String?
    let city: String?
}

struct CustomerList :Codable{
    var customers:[Customer]
}
