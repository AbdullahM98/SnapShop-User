//
//  PriceRule.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

struct PriceRulesArray: Codable {
    let price_rules: [PriceRule]?
}

struct PriceRulesRoot: Codable{
    let price_rule: PriceRule?
}

struct PriceRule:Codable,Hashable {
    let id: Int?
    let value_type:String?
    let value: String?
    let customer_selection:String?
    let title:String?
}
