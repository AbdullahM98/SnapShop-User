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
    let handler = NotificationHandler()
    init(){
        FirebaseApp.configure()
        handler.askPermission()
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

       
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
}
