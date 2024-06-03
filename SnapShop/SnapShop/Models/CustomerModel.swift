//
//  CustomerModel.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import Foundation

struct CustomerModel :Codable {

    var first_name            : String      = ""
    var last_name             : String      = ""
    var email                : String      = ""
    var phone                : String      = ""
    var verified_email        : Bool        = true
    var addresses            : [Address] = []
    var password             : String      = ""
    var password_confirmation : String      = ""
  
   
    init(firstName: String = "", lastName: String = "", email: String = "", phone: String = "", verifiedEmail: Bool = true, addresses: [Address] = [], password: String = "", passwordConfirmation: String = "") {
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
        self.phone = phone
        self.verified_email = verifiedEmail
        self.addresses = addresses
        self.password = password
        self.password_confirmation = passwordConfirmation
    }
}

struct CustomersList : Codable {
    var customers : [Customers]
}
