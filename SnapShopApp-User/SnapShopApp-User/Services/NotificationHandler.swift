//
//  NotificationHandler.swift
//  SnapShopApp-User
//
//  Created by husayn on 14/06/2024.
//

import Foundation
import UserNotifications

class NotificationHandler {
    let titles:[String] = ["SAVE BIG MONEY","EPIC DEAL","Better late than never!","Go ahead, take a peek","Dress to impress", "BEEP, BEEP","Flash sale alert:", "SHARE & EARN", "Big news!","Heat Up Your Shopping!"]
    let bodies:[String] = ["That's Right! Don't Wait to Shop!","Don't Miss This Opportunity!","Get your hands on the hottest styles for less! Shop our exclusive discounts now!","Check out our incredible discounts, exclusively for our fashion forward customers.","These deals are too hot to last! Don't wait, the best deals will go quickly.", "Must-See Pricess","Get up to 50% off on your favorite styles!"]
    func askPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]){
            success, error in
            if success{
                print("Access granted")
            }else if let error = error {
                print(error.localizedDescription)
            }else {
                print("Permission denied")
            }
        }
    }
    func createNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = titles.randomElement() ?? "Dress to Impress"
        content.body = bodies.randomElement() ?? "Don't Miss This Opportunity!"
        return content
    }
    func createNotificationTrigger() -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return trigger
    }
    func scheduleHourlyNotification(){
        let content = createNotificationContent()
        let trigger = createNotificationTrigger()
        let request = UNNotificationRequest(identifier: "hourly_notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){
            error in
            if let error = error {
                print("error adding notification: \(error.localizedDescription)")
            }else{
                print("HourlyNotification Scheduled")
            }
        }
    }
    
    //call askPermission and scheduleHoulryNotification
    //or call askPermission and sendNotificaiotn
    func sendNotification(date: Date,type: String,timeInterval: Double = 10){
        var trigger: UNNotificationTrigger?
        if type == "date"{
            let dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
        }else if type == "time"{
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        let content = UNMutableNotificationContent()
        content.title = titles.randomElement() ?? "Dress to Impress"
        content.body = bodies.randomElement() ?? "Don't Miss This Opportunity!"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
}

class NotificationDelegate:NSObject,UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
}
