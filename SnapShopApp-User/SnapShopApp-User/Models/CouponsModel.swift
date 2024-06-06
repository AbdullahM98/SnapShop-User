//
//  CouponsModel.swift
//  SnapShop
//
//  Created by husayn on 01/06/2024.
//

import Foundation


struct DiscountCodesRoot : Codable{
    let discount_codes: [DiscountCodes]?
    
}
struct DiscountCodes :Codable{
    let id:Int?
    let price_rule_id:Int?
    let code: String?
    let usage_count:Int?
    let created_at:String?
    let updated_at:String?
}
