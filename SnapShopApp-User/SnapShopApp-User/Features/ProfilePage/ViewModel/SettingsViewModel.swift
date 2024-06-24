//
//  SettingsViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 11/06/2024.
//

import Foundation

class SettingsViewModel:ObservableObject{
    @Published var isGuest :Bool = true
    @Published var fireBaseUserId : Int? = UserDefaultsManager.shared.getUserId(key: Support.userID)
    @Published var shopifyCustomerId : String?
    @Published var userEmail: String?
    @Published var showBottomSheet = true
    
    
}

