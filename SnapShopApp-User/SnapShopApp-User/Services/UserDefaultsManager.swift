//
//  AppUserDefault.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//

import Foundation


class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private init() {}

   
    func setIsloggedIn(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }


    func getIsloggedIn(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setUserId(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }

    
    func getUserId(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    var selectedCurrencyCode: String? {
        get{
            return UserDefaults.standard.string(forKey: "selectedCurrency")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "selectedCurrency")
        }
    }
    var selectedCurrencyValue: String? {
        get{
            return UserDefaults.standard.string(forKey: "currencyValue")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "currencyValue")
        }
    }
    var selectedCouponCodeValue: String? {
        get{
            return UserDefaults.standard.string(forKey: "couponCode")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "couponCode")
        }
    }
    var priceRuleIdForCoupon: Int? {
        get{
            return UserDefaults.standard.integer(forKey: "priceRuleId")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "priceRuleId")
        }
    }
    var notifyCart: Int? {
        get{
            return UserDefaults.standard.integer(forKey: "notifyCart")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "notifyCart")
        }
    }
    
    var hasDraft: Bool? {
        get{
            UserDefaults.standard.bool(forKey: "HasDraft")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "HasDraft")
        }
    }
    
    var userDraftId: Int? {
        get{
            UserDefaults.standard.integer(forKey: "UserDraftId")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "UserDraftId")
        }
    }
}
