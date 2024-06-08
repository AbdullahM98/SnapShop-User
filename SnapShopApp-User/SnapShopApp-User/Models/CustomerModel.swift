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


//MARK: - this is for profile
struct CustomerResponse: Codable {
    let customer: CustomerDetails?
}
struct CustomerDetails: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: Int?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let addresses: [AddressResponse]?
    let tax_exemptions: [String]?
    let email_marketing_consent: EmailMarketingConsent?
    let sms_marketing_consent: SMSMarketingConsent?
    let admin_graphql_api_id: String?
    let default_address: AddressResponse?
    
    
}
struct AddressesRequest:Codable{
    let addresses: [AddressResponse]?
}
struct AddressResponse: Codable {
    let id: Int?
    let customer_id: Int?
    let first_name: String?
    let last_name: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let province_code: String?
    let country_code: String?
    let country_name: String?
    let `default`: Bool?
}
        

struct EmailMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
}

struct SMSMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}

struct AddressRequestToPost :Codable{
    let customer_address: CustomerAddressToPost?
}
struct CustomerAddressToPost: Codable{
    let id: Int?
    let customer_id: Int?
    let address1: String?
    let address2: String?
    let city: String?
    let zip: String?
    let phone: String?
    let name: String?
    let province_code: String?
    let country_code: String?
    let country_name: String?
    let `default`: Bool?
}
