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
                    Text("Cart")
                case .saved:
                    Text("Saved")
                case .profile:
                    Text("Profile")
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
