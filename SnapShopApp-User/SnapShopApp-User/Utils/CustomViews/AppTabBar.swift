////
////  AppTabBar.swift
////  SnapShop
////
////  Created by husayn on 24/05/2024.
////
//
//import SwiftUI
//
//enum Tabs:Int{
//    case home = 0, explore, cart, saved, profile
//}
//
//struct AppTabBar: View {
//    @Binding var selectedTab:Tabs
//    var body: some View {
//        HStack (alignment: .center){
//            Button {
//                //switch to home
//                selectedTab = .home
//            } label: {
//                TabBarButton(buttonText: "Home", imageName: "home", isActive: selectedTab == .home)
//            }.tint(Theme.primaryColor)
//            Button {
//                //switch to collections
//                selectedTab = .explore
//            } label: {
//                TabBarButton(buttonText: "Explore", imageName: "search", isActive: selectedTab == .explore)
//            }.tint(Theme.primaryColor)
//            Button {
//                //switch to cart
//                selectedTab = .cart
//            } label: {
//                TabBarButton(buttonText: "Cart", imageName: "cart", isActive: selectedTab == .cart)
//            }.tint(Theme.primaryColor)
//            Button {
//                //switch to saved
//                selectedTab = .saved
//            } label: {
//                TabBarButton(buttonText: "Saved", imageName: "heart", isActive: selectedTab == .saved)
//            }.tint(Theme.primaryColor)
//            Button {
//                //switch to profile
//                selectedTab = .profile
//            } label: {
//                TabBarButton(buttonText: "Profile", imageName: "person", isActive: selectedTab == .profile)
//            }.tint(Theme.primaryColor)
//            
//        }.frame(height: 82 )
//            .ignoresSafeArea(edges: .bottom)
//    }
//}
//
//struct AppTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        AppTabBar(selectedTab: .constant(.home))
//    }
//}
