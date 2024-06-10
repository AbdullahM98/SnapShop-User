//
//  ContentView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab:Tabs = .home
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {

        NavigationStack{
            VStack {
                switch selectedTab{
                case .home:
                    HomeView(viewModel: viewModel)
                case .explore:
                    CategoryView(viewModel: viewModel)
                case .cart:
                    CartList()
                case .saved:
                    Text("Saved")
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
