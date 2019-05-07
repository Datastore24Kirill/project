//
//  AppDelegate.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 26.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import FBSDKCoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
          
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    static func getWindow() -> UIWindow? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCrc9QSbo7GcfrJLnomsNGaB1umJdL5kY4")
        GMSServices.provideAPIKey("AIzaSyBniHWkFmUP2IwHzLshmH2_yeRvQ-y_LpM")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide

        setDefaultLanguage()
        prepareFirstView()
        
        NotificationManager.shared.setup()
        LocationManager.share.setup()
        
       
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {


        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        //return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func prepareFirstView() {
        
      
//        let storyboard = InternalHelper.StoryboardType.emailVerification.getStoryboard()
//        let emailVerificationVC = storyboard.instantiateViewController(withIdentifier: "EmailVerificationVC")
//
//        if let window = self.window {
//            window.rootViewController = emailVerificationVC
//        }
        
        
        
        if let userInfo = UserDefaultsVerifier.getUser() {
            print("USERINFO ->> \(userInfo)")
            if userInfo.isPromoViewed == nil{
                
                let storyboard = InternalHelper.StoryboardType.promo.getStoryboard()
                let promoVC = storyboard.instantiateViewController(withIdentifier: "PromoVC")
                if let window = self.window {
                    window.rootViewController = promoVC
                }
            } else if let isPromoViewed = userInfo.isPromoViewed,
                isPromoViewed == "false"{
                
                let storyboard = InternalHelper.StoryboardType.promo.getStoryboard()
                let promoVC = storyboard.instantiateViewController(withIdentifier: "PromoVC")
                if let window = self.window {
                    window.rootViewController = promoVC
                }
                
            } else {
                
                let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
                let dashoboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardNAVVC")
                if let window = self.window {
                    window.rootViewController = dashoboardVC
                }
                
            }
            
        } else {
            let storyboard = InternalHelper.StoryboardType.promo.getStoryboard()
            let promoVC = storyboard.instantiateViewController(withIdentifier: "PromoVC")
            if let window = self.window {
                window.rootViewController = promoVC
            }
        }
        
    }

    func reloginUser() {
        let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
        let loginVC = storyboard.instantiateInitialViewController()
        if let window = self.window {
            window.rootViewController = loginVC
        }
    }

    func setDefaultLanguage() {
        
        if UserDefaults.standard.value(forKey: "lang") == nil {

            let pre = Locale.current.languageCode;
            print("PRE LANGUAGE \(pre)")
            switch pre {
            case "ru", "en":
                UserDefaults.standard.setValue(pre, forKey: "lang")
            default:
                UserDefaults.standard.setValue("en", forKey: "lang")
            }
        }
    }
}

