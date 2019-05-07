//
//  NotificationManager.swift
//  Verifier
//
//  Created by Dima Paliychuk on 6/12/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import FirebaseMessaging


enum NotificationType: String, EnumCollection {
    
    case message = "message"
    
    static func fromPush(dictionary: [AnyHashable : Any]) -> NotificationType? {
        if let type = dictionary["imago_type"] as? NSString {
            for enumCase in NotificationType.allValues {
                if type as String == enumCase.rawValue {
                    return enumCase
                }
            }
        }
        return nil
    }
}


class NotificationManager: NSObject {

    //MARK: shared
    
    static let shared = NotificationManager()
    
    
    //MARK: setup
    
    func setup() {
        registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func registerForRemoteNotifications() {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension NotificationManager : UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification: Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("")
        completionHandler(.newData)
    }
}

extension NotificationManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Refresh Token")
         print("Firebase registration token: \(fcmToken)")
         UserDefaultsVerifier.setPushToken(with: fcmToken)
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
       
        
    }
    
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("")
    }
}

