//
//  AddressesModels.swift
//  SnapShopApp-User
//
//  Created by husayn on 10/06/2024.
//

import Foundation
struct AddressProfileRoot:Codable{
    let addresses: [AddressProfileDetails]?
}
struct AddressForUpdate: Codable{
    let customer_address: AddressProfileDetails?
}
struct AddressProfileDetails: Codable {
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
