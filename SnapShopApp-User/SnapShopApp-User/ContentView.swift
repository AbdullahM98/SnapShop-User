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
    @AppStorage("currentPage") var currentPage = 1
    let handler = NotificationHandler()
    var body: some View {
        VStack{
            if currentPage > totalPages {
                BaseView()
            }else{
                OnBoardingView()
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                handler.askPermission()
                handler.sendNotification(date: Date(), type: "time", timeInterval: 60 * 5)
                locationViewModel.requestLocation()
            }
        


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
