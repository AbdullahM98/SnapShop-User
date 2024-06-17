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
    
    func setUserHasDraftOrders(key: String, value:Bool){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getUserHasDraftOrders(key: String)->Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    func setUserDraftOrderId(key: String, value:Int){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getUserDraftOrderId(key: String)->Int? {
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
}
