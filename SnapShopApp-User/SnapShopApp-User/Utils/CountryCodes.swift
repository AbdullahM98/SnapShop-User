//
//  CountryCodes.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 19/06/2024.
//

import Foundation


enum CountryCode: String, CaseIterable, Identifiable {
    case Afghanistan = "AF"
    case Brazil = "BR"
    case Canada = "CA"
    case Denmark = "DK"
    case Egypt = "EG"
    case France = "FR"
    case Germany = "DE"
    case India = "IN"
    case Japan = "JP"
    case Mexico = "MX"
    case Norway = "NO"
    case SouthAfrica = "ZA"
    
    var id: String { self.rawValue }
    
    var countryName: String {
        switch self {
        case .Afghanistan: return "Afghanistan"
        case .Brazil: return "Brazil"
        case .Canada: return "Canada"
        case .Denmark: return "Denmark"
        case .Egypt: return "Egypt"
        case .France: return "France"
        case .Germany: return "Germany"
        case .India: return "India"
        case .Japan: return "Japan"
        case .Mexico: return "Mexico"
        case .Norway: return "Norway"
        case .SouthAfrica: return "South Africa"
        }
    }
}
