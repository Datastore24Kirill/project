//
//  AppDelegate.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 22/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import Firebase
import FacebookCore
import SwiftyVK
import RealmSwift
import MBProgressHUD
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var indicator = UIActivityIndicatorView()
    
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

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCrc9QSbo7GcfrJLnomsNGaB1umJdL5kY4")
        GMSServices.provideAPIKey("AIzaSyBniHWkFmUP2IwHzLshmH2_yeRvQ-y_LpM")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        
        setDefaultLanguage()
        prepareFirstView()
        DropDown.startListeningToKeyboard()
        
        NotificationManager.shared.setup()
        LocationManager.share.setup()
        print("Path to REALM \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        
    }
    func prepareFirstView() {
        
        showSpinner()
        let resultRealm = RealmSwiftAction.listRealm()
        
       

        if  let token = resultRealm.first?.enterToken, token != "" {
            print("RESSSS \(token)")
            didCheckToken()
        } else {
            
            let storyboard = InternalHelper.StoryboardType.splashScreen.getStoryboard()
            let splashScreenVC = storyboard.instantiateViewController(withIdentifier: "SplashScreenNAVVC")
            
            if let window = self.window {
                window.rootViewController = splashScreenVC
            }
            
        }
        
        
          
    }
    
    func reloginUser() {
        let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
        let loginVC = storyboard.instantiateViewController(withIdentifier: "SignInNAVVC")
        if let window = self.window {

            window.rootViewController = loginVC
        }
    }

    func showDashBoard() {
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardNAVVC")
        
        if let window = self.window {
            window.rootViewController = dashboardVC
        }
    }
    
    func showProfile() {
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let dashboardNAVVC = storyboard.instantiateViewController(withIdentifier: "DashboardNAVVC") as! UITabBarController
        
        dashboardNAVVC.selectedIndex = 2;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = dashboardNAVVC
    }
    
    func showNoVerification(){
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.noVerifierVC.rawValue
        
        if let noVerifierVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? NoVerifierUserViewController {
            if let window = self.window {
                window.rootViewController = noVerifierVC
            }
            
        }
    }
    
    func setDefaultLanguage() {
        
        if UserDefaults.standard.value(forKey: "lang") == nil {
            
            let pre = Locale.current.languageCode;
            print("PRE LANGUAGE \(pre ?? "")")
            switch pre {
            case "ru", "en":
                UserDefaults.standard.setValue(pre, forKey: "lang")
            default:
                UserDefaults.standard.setValue("ru", forKey: "lang")
            }
        }
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
    
    //MARK: CHECKTOKEN
    
    func didCheckToken() {
        let apiRequestManager = RequestHendler()
        
        apiRequestManager.checkToken(){ (data, result) in
            switch result {
            case .success:
                self.hideSpinner()
                if let dict = data {
                    print("DICT \(dict)")
                    if let isTempPassword = dict["isTempPassword"] as? Int,
                        isTempPassword == 1 {
                        let storyboard = InternalHelper.StoryboardType.splashScreen.getStoryboard()
                        let splashScreenVC = storyboard.instantiateViewController(withIdentifier: "SplashScreenNAVVC")
                        
                        if let window = self.window {
                            window.rootViewController = splashScreenVC
                        }
                        
                        
                    } else if let verificationStatus = dict["verificationStatus"] as? Int {
                        switch verificationStatus {
                        case 0:

                            self.showNoVerification()
                    
                        case 1,2:
                            
                            self.showDashBoard()
                            
                            
                        case 3:
                            
                            self.showProfile()
                            
                        default:
                            break
                        }
                        
                        
                    }
                    
                }
            case .failed, .serverError:
                self.hideSpinner()
                print("ERROR")
            case .noInternet:
                print("No Internet")
                self.hideSpinner()
                self.showAlertNoInternet(){
                    self.didCheckToken()
                }
            default:
                print ("error")
                
            }
        }
        
    }
    
    
    //MARK: UIActivity Indicator
   
    func showSpinner() {
    
        if let view =  window?.rootViewController?.view {
            MBProgressHUD.showAdded(to: view, animated: true)
        }

        
    }
    
    func hideSpinner() {
        
        if let view =  window?.rootViewController?.view {
            MBProgressHUD.hide(for: view, animated: true)
        }
        
    }
    
    func showAlertNoInternet(closure: @escaping (()->())){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error".localized(), message: "Error.NoInternet".localized(), preferredStyle: .alert)
            let action = UIAlertAction(title: "Повторить запрос", style: .default) { (_) in
                closure()
                
            }
            alert.addAction(action)
            if let viewController =  self.window?.rootViewController {
                viewController.present(alert, animated: true, completion: nil)
            }
            
        }
    }


}

