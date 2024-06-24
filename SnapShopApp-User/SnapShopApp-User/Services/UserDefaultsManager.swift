//
//  AppUserDefault.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//

import Foundation

// MARK: - UserDefaultsManager Class

class UserDefaultsManager {
    // MARK: - Singleton Instance
    
    static let shared = UserDefaultsManager()
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Logged In Status
    
    // Set the login status
    func setIsloggedIn(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // Get the login status
    func getIsloggedIn(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    // MARK: - User ID
    
    // Set the user ID
    func setUserId(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // Get the user ID
    func getUserId(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    // MARK: - Currency Settings
    
    // Selected currency code
    var selectedCurrencyCode: String? {
        get {
            return UserDefaults.standard.string(forKey: "selectedCurrency")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedCurrency")
        }
    }
    
    // Selected currency value
    var selectedCurrencyValue: String? {
        get {
            return UserDefaults.standard.string(forKey: "currencyValue")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currencyValue")
        }
    }
    
    // MARK: - Coupon Code
    
    // Selected coupon code value
    var selectedCouponCodeValue: String? {
        get {
            return UserDefaults.standard.string(forKey: "couponCode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "couponCode")
        }
    }
    
    // Price rule ID for coupon
    var priceRuleIdForCoupon: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "priceRuleId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "priceRuleId")
        }
    }
    
    // MARK: - Notification Settings
    
    // Notify cart status
    var notifyCart: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "notifyCart")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notifyCart")
        }
    }
    
    // MARK: - Draft Settings
    
    // Check if there is a draft
    var hasDraft: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "HasDraft")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HasDraft")
        }
    }
    
    // User draft ID
    var userDraftId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "UserDraftId")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "UserDraftId")
        }
    }
}
