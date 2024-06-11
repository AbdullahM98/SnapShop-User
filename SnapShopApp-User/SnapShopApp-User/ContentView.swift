//
//  ContentView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab:Tabs = .home
    var body: some View {

        NavigationStack{
            VStack {
                switch selectedTab{
                case .home:
                    HomeView()
                case .explore:
                    CategoryView()
                case .cart:
                    CartList()
                case .saved:
                    FavoriteView()
                case .profile:
                    ProfileView()
                }
                Spacer()
                AppTabBar(selectedTab: $selectedTab)
            }.ignoresSafeArea(edges: .bottom)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
