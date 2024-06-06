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

    // Function to set a value with a dynamically generated key
    func setDynamicValue(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }

    // Function to get a value using a dynamically generated key
    func getDynamicValue(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
}
