//
//  ContentView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
//    @State var selectedTab:Tabs = .home
    @StateObject private var networkMonitor = NetworkMonitor()
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        VStack{
            if currentPage > totalPages {
                BaseView()
            }else{
                OnBoardingView()
            }
        }.navigationBarBackButtonHidden(true)
        
//        BaseView()
//        NavigationStack{
//            VStack {
//                switch selectedTab{
//                case .home:
//                    HomeView()
//                case .explore:
//                    CategoryView()
//                case .cart:
//                    CartList()
//                case .saved:
//                    FavoriteView()
//                case .profile:
//                    ProfileView()
//                }
//                Spacer()
//                AppTabBar(selectedTab: $selectedTab)
//            }.navigationBarBackButtonHidden(true).ignoresSafeArea(edges: .bottom)
//                .onAppear {
//                    
//                }
//                .onChange(of: networkMonitor.isConnected) { isConnected in
//                    SnackBarHelper.showSnackBar(isConnected: isConnected)
//                }
//        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
