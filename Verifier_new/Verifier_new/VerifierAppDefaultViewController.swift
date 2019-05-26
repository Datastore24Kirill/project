//
//  VerifierAppDefaultViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 22/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import PopupDialog
import CoreLocation
import MapKit

import AVFoundation

class VerifierAppDefaultViewController: UIViewController {

    func showSpinner() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideSpinner() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String, action: UIAlertAction) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
   
    
    func showAlertNoInternet(closure: @escaping (()->())){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error".localized(), message: "Error.NoInternet".localized(), preferredStyle: .alert)
            let action = UIAlertAction(title: "Повторить запрос", style: .default) { (_) in
                closure()
                
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    struct ButtonTypeStruct {
        enum Types: String {
            case CancelButton = "CancelButton"
            case DefaultButton = "DefaultButton"
            case ActionButton = "ActionButton"
        }
        
        var buttonsArray = [[String:String]]()
        
        mutating func createButtonsArray(type: Types, title: String, url: String?){
            
            var dict = ["type" : type.rawValue, "title" : title]
            if let urlResult = url {
                dict["url"] = urlResult
            }
            buttonsArray.append(dict)
        }
        
    }
    
    //MARK: - POPUP
    
    func showPopUpDialog(title: String, message: String, buttonArray: [[String:String]], closure: @escaping (()->())) {
        // Prepare the popup assets
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        //Type
        //title
        //url?
        var buttonsArray = [PopupDialogButton]()
        for dict in buttonArray {
           
            if let type = dict["type"],
                let title = dict["title"] {
                
                let tempType = ButtonTypeStruct.Types(rawValue: type)
                
                
                if tempType == ButtonTypeStruct.Types.DefaultButton {
                    if let url = dict["url"] {
                        let buttonDefault = DefaultButton(title: title) {
                            guard let url = URL(string: url) else {
                                return //be safe
                            }
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                         buttonsArray.append(buttonDefault)
                    }
                } else if tempType == ButtonTypeStruct.Types.CancelButton {
                        let buttonCancel = CancelButton(title: title, action: nil)
                        buttonsArray.append(buttonCancel)
                } else if tempType == ButtonTypeStruct.Types.ActionButton {
                    
                    let buttonAction = DefaultButton(title: title) {
                        closure()
                    }
                    buttonsArray.append(buttonAction)
                    
                }
                
            }
            
        }
        print("Button \(buttonsArray)")
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons(buttonsArray)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    //MARK: - PopUps
    
    func showNeedTraining(link: String?){
        var buttons = ButtonTypeStruct()
        if let linkString = link {
                buttons.createButtonsArray(type: ButtonTypeStruct.Types.DefaultButton, title: "Training".localized(), url:linkString)
        }
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.CancelButton, title: "Close".localized(), url: nil)
        
        showPopUpDialog(title: "AllTask.NeedTraining.Title".localized(), message: "AllTask.NeedTraining.Msg".localized(), buttonArray: buttons.buttonsArray){
            
        }
        
        
        
        
    }
    
    func showTaskStepInfo(info: String){
        var buttons = ButtonTypeStruct()
        
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.CancelButton, title: "Аcquainted".localized(), url: nil)
        
        showPopUpDialog(title: "Task.Title".localized(), message: info, buttonArray: buttons.buttonsArray){
            
        }
        
        
        
        
    }
    
    func showEmailVerificationPopUp (confirmationEmail: String, closure: @escaping (()->())) {
        var buttons = ButtonTypeStruct()
        
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.ActionButton, title: "Resend".localized(), url:nil)
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.CancelButton, title: "Close".localized(), url: nil)
        showPopUpDialog(title: "EmailVerificationError.Title".localized(), message: "EmailVerificationError.Msg.FirstSend".localized(param: confirmationEmail), buttonArray: buttons.buttonsArray){
            closure()
//            self.model.didResendVerifierEmail(with: confirmationEmail)
        }
    }
    func showEmailVerificationAlredySendPopUp (confirmationEmail: String, closure: @escaping (()->())) {
        var buttons = ButtonTypeStruct()
        
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.ActionButton, title: "IConfirmEmail".localized(), url:nil)
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.CancelButton, title: "Close".localized(), url:nil)
        showPopUpDialog(title: "EmailVerificationError.Title".localized(), message: "EmailVerificationError.Msg.ReSend".localized(param: confirmationEmail), buttonArray: buttons.buttonsArray){
            closure()
        }
    }
    
    func showResetPasswordPopUp (closure: @escaping (()->())) {
        var buttons = ButtonTypeStruct()
        
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.ActionButton, title: "Good".localized(), url:nil)
        showPopUpDialog(title: "FogotPassword.PopUp.Title".localized(), message: "FogotPassword.PopUp.Msg".localized(), buttonArray: buttons.buttonsArray){
            closure()
        }
    }
    
    func showChangePasswordPopUp (closure: @escaping (()->())) {
        var buttons = ButtonTypeStruct()
        
        buttons.createButtonsArray(type: ButtonTypeStruct.Types.ActionButton, title: "Good".localized(), url:nil)
        showPopUpDialog(title: "FogotPassword.PopUp.ResetPassword.Title".localized(), message: "FogotPassword.PopUp.ResetPassword.Msg".localized(), buttonArray: buttons.buttonsArray){
            closure()
        }
    }
    
    //MARK: RATING POPUP
    
    func showRateAppDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "Close".localized(), height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Rate".localized(), height: 60) {
            self.rateApp()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    //MARK: RATE APP
    private func rateApp() {
        print("RateApp OK")
        openUrl("itms-apps://itunes.apple.com/app/id1450522030")
    }
    
    
    
    private func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK: RATING TaSK POPUP
    
    func showRateTaskDialog(animated: Bool = true, closure: @escaping ((Double)->())) {
        
        // Create a custom view controller
        let ratingTaskVC = RatingTaskViewController(nibName: "RatingTaskViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingTaskVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "Close".localized(), height: 60) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Rate".localized(), height: 60) {
            closure(ratingTaskVC.cosmosStarRating.rating)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    //MARK: - DAYS in Text
    func dayStringFromNumberOfDays(_ numberOfDays: Int) -> String {
        let lastDigit = numberOfDays % 10
        if (numberOfDays >= 11 && numberOfDays <= 19)
        {
            return "дней";
        }
        else
        {
            if lastDigit == 1 { return "день" };
            if lastDigit > 1 && lastDigit < 5 { return "дня" };
            if lastDigit == 0 || lastDigit >= 5 { return "дней" };
        }
        return ""
    }
    
    //MARK: - OPEN MAPS
    
    func googleMapsBuildARouteFromPoint(lat: Float, lng: Float, name: String) {
        
        let latitude = CLLocationDegrees(lat)
        let longitude = CLLocationDegrees(lng)
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        
        let yandexURL = "yandexnavi://build_route_on_map?lat_to=\(latitude)&lon_to=\(longitude)"
        
        if UIApplication.shared.canOpenURL(URL(string: yandexURL)!) {
            UIApplication.shared.open((NSURL(string: yandexURL)! as URL), options: [:], completionHandler: nil)
            
        } else {
            if !mapItem.openInMaps(launchOptions: options) {
                
                if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                    UIApplication.shared.open((NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(lat),\(lng)")! as URL), options: [:], completionHandler: nil)
                }
            }
        }
        
        
    }
    
    //MARK: - STATUS
    
    func getStatus(status: String) -> [String: String] {
        var dict = [String: String]()
        switch status {
        case "CREATED": //CREATE
            dict["name"] = "status.CREATED".localized()
            dict["color"] = "#A5AEB7"
            
        case "ACCEPTED": //ACCEPTED
            dict["name"] = "status.ACCEPTED".localized()
            dict["color"] = "#07B1D8"
            
        case "VERIFIED": //VERIFIED
            dict["name"] = "status.VERIFIED".localized()
            dict["color"] = "#DBB705"
            
        case "APPROVE": //APPROVE
            dict["name"] = "status.APPROVE".localized()
            dict["color"] = "#3BBEAB"
            
        case "RETURNED_TO_VERIFIER": //RETURNED
            dict["name"] = "status.RETURNEDTOVERIFIER".localized()
            dict["color"] = "#ED0648"
            
        default:
            break
        }
        return dict
    }
    
    //MARK: Get Thumb of Video
    
    func generateThumbImage(url : URL?) -> UIImage? {
        if url != nil {
            let asset = AVAsset(url: url!)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            
            var time = asset.duration
            time.value = min(time.value, 2)
            
            do {
                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                return UIImage(cgImage: imageRef)
            } catch {
                print("error")
                return nil
            }
        } else {
            return nil
        }
       
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
    
    func locolizeTabBar() {
        self.tabBarController?.tabBar.items?[0].title = "TabBar.AllTask".localized()
        self.tabBarController?.tabBar.items?[1].title = "TabBar.MyTask".localized()
        self.tabBarController?.tabBar.items?[2].title = "TabBar.Profile".localized()
        self.tabBarController?.tabBar.items?[3].title = "TabBar.Help".localized()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToArray(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToJSONString(object: Any) -> String? {
        do {
            let data =  try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            return String(data: data, encoding: String.Encoding.utf8) // the data will be converted to the string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        
        return nil
        
    }
        
 
}

