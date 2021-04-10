//
//  AppDelegate.swift
//  GeoFence
//
//  Created by Rahul Bawane on 10/04/21.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, error in
          if let error = error {
            print("Error: \(error)")
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

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == REGION_IDENTIFIER {
            handleNotifications(message: "Hi! Welcome to Mumbai")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == REGION_IDENTIFIER {
            handleNotifications(message: "Bye! Thanks for visiting Mumbai")
        }
    }
    
    func handleNotifications(message: String) {
        if UIApplication.shared.applicationState == .active {
            UIApplication.shared.keyWindow?.rootViewController?.showAlert(withTitle: "", message: message)
         } else {
        let notificationContent = UNMutableNotificationContent()
           notificationContent.body = message
           notificationContent.sound = .default
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
           let request = UNNotificationRequest(identifier: "location_change", content: notificationContent, trigger: trigger)
           UNUserNotificationCenter.current().add(request) { error in
             if let error = error {
               print("Error: \(error)")
             }
           }
         }
    }
}
