//
//  SnapShopApp_UserApp.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//
import FirebaseCore

import SwiftUI

@main
struct SnapShopApp_UserApp: App {
    init(){
       FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
   // FirebaseApp.configure()
    return true
  }
}
