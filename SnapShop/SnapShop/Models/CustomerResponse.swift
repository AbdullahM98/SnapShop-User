//
//  CustomerResponse.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import Foundation

// CustomerRequest struct
struct CustomerRequest: Codable {
    let customer: Customer
}

// Customer struct
struct Customer: Codable {
    let password_confirmation: String
    let phone: String
    let password: String
    let last_name: String
    let send_email_welcome: Bool
    let verified_email: Bool
    let addresses: [Address]
    let email: String
    let first_name: String
}


struct Address: Codable {
    let phone: String
    let country: String
    let province: String
    let zip: String
    let address1: String
    let first_name: String
    let last_name: String
    let city: String
}

// CustomerResponse struct
struct CustomerResponse: Codable {
    let customers: [Customers]
}

// Customers struct
struct Customers: Codable {
    let id: Int?
       let email: String?
       let first_name: String?
       let last_name: String?
       let phone: String?
       let verified_email: Bool?
       let addresses: [Address]?
       let created_at: String?
       let updated_at: String?
}

// AddressResponse struct
struct AddressResponse: Codable {
    let id: Int64
    let customer_id: Int64
    let first_name: String
    let last_name: String
    let company: String?
    let address1: String
    let address2: String?
    let city: String
  //  let province: String
    let country: String
    let zip: String
    let phone: String
    let name: String
  //  let province_code: String
    let country_code: String
    let country_name: String
    let isDefault: Bool
}

// MarketingConsent struct
struct MarketingConsent: Codable {
    let state: String
    let opt_in_level: String
    let consent_updated_at: String?
}

// SmsMarketingConsent struct
struct SmsMarketingConsent: Codable {
    let state: String
    let opt_in_level: String
    let consent_updated_at: String?
    let consent_collected_from: String
}
