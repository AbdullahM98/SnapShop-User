//
//  BaseViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 18/06/2024.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var currentTab: Tab = .Home
}

enum Tab: String{
    case Home = "Home"
    case Explore = "Category"
    case Favorites = "Favorite"
    case Profile = "Profile"
    
}
