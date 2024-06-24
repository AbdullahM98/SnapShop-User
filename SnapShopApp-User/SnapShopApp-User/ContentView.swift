//
//  ContentView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @State var endAnimation: Bool = false
    @AppStorage("currentPage") var currentPage = 1
    let handler = NotificationHandler()
    var body: some View {
        ZStack{
            VStack{
                if currentPage > totalPages {
                    BaseView()
                }else{
                    OnBoardingView()
                }
            }
            //.offset(y: endAnimation ? 0 : getRect().height)
            .navigationBarBackButtonHidden(true)
                .onAppear{
                    handler.askPermission()

                    locationViewModel.requestLocation()

                    handler.sendNotification(date: Date(), type: "time", timeInterval: 3600)

                }
            SplashScreen(endAnimation: $endAnimation)
        }
        /*VStack{
            if currentPage > totalPages {
                BaseView()
            }else{
                OnBoardingView()
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                handler.askPermission()

                locationViewModel.requestLocation()

                handler.sendNotification(date: Date(), type: "time", timeInterval: 3600)

            }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
