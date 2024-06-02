//
//  ContentView.swift
//  SnapShop
//
//  Created by Abdullah Essam on 21/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab:Tabs = .home
    var body: some View {
        VStack {
            switch selectedTab{
            case .home:
                HomeView()
            case .explore:
                Text("Explore")
            case .cart:
                Text("Cart")
                CartList()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
