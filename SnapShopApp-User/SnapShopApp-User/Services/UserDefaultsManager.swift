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
}
