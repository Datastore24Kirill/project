//
//  NotificationManager.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        
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
        RealmSwiftAction.updateRealm(verifierId: nil, enterToken: nil, pushToken: fcmToken, isFirstLaunch: nil)
        
        let resultsRealm = RealmSwiftAction.listRealm().first
            
        if resultsRealm?.enterToken != nil, resultsRealm?.enterToken != "" {
            sendPushToken(pushToken: fcmToken)
        }
        
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        
        
    }
    
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("")
    }
    
    func sendPushToken(pushToken: String) {
        let apiRequestManager = RequestHendler()
        
        let parametrs = ["pushToken": pushToken]
        apiRequestManager.push(parameters: parametrs) {
            switch $0 {
            case .success:
                print("--> Token Send")
            case .failed, .serverError:
                print("ERROR")
            case .noInternet:
                print("ERROR")
            default:
                print ("error")
                
            }
        }
        
    }
}

