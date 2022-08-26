//
//  AppDelegate.swift
//  Drink
//
//  Created by Yujean Cho on 2022/04/08.
//

import UIKit
import NotificationCenter
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // NotificationCenter
        UNUserNotificationCenter.current().delegate = self
        
        // UserNotifications
        // alert 에 대한 사용자의 권한이 필요하다.
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authorizationOptions) { _, error in
            if let error = error {
                print("ERROR: notification authrization request \(error.localizedDescription)")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// UserNotification Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
