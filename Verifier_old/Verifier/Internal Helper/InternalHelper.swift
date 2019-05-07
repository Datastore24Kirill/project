//
//  InternalHelper.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import MapKit

class InternalHelper {
    
    //MARK:- Shared Instance Implementation
    static let sharedInstance = InternalHelper()
    
    enum StoryboardType {
        case profile
        case dashboard
        case detail
        case signIn
        case signUp
        case signUpStepTwo
        case qrCode
        case task
        case other
        case map
        case menu
        case alertError
        case settings
        case filter
        case promo
        case fogotPassword
        case jivoSite
        case emailVerification
        
        func getStoryboard() -> UIStoryboard {
            switch self {
            case .profile:
                return UIStoryboard(name: "Profile", bundle: nil)
            case .signIn:
                return UIStoryboard(name: "SignIn", bundle: nil)
            case .signUp:
                return UIStoryboard(name: "SignUp", bundle: nil)
            case .signUpStepTwo:
                return UIStoryboard(name: "SignUpStepTwo", bundle: nil)
            case .promo:
                return UIStoryboard(name: "Promo", bundle: nil)
            case .fogotPassword:
                return UIStoryboard(name: "FogotPassword", bundle: nil)
            case .qrCode:
                return UIStoryboard(name: "QRCode", bundle: nil)
            case .dashboard:
                return UIStoryboard(name: "Dashboard", bundle: nil)
            case .detail:
                return UIStoryboard(name: "Detail", bundle: nil)
            case .task:
                return UIStoryboard(name: "Task", bundle: nil)
            case .other:
                return UIStoryboard(name: "Other", bundle: nil)
            case .map:
                return UIStoryboard(name: "Map", bundle: nil)
            case .menu:
                return UIStoryboard(name: "Menu", bundle: nil)
            case .alertError:
                return UIStoryboard(name: "AlertError", bundle: nil)
            case .settings:
                return UIStoryboard(name: "Settings", bundle: nil)
            case .filter:
                return UIStoryboard(name: "Filter", bundle: nil)
            case .jivoSite:
                return UIStoryboard(name: "JivoSite", bundle: nil)
            case .emailVerification:
                return UIStoryboard(name: "EmailVerification", bundle: nil)
            }
        }
        
        func getViewControllerIdentifier()->String {
            return ""
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func normalizedImage(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage;
    }

    func getSecondFromVideo(asset: AVAsset) -> Float64 {
        return CMTimeGetSeconds(asset.duration)
    }

    func thumbnailForVideoAtURL(asset: AVAsset) -> UIImage? {

        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true

        var time = asset.duration
        time.value = min(time.value, 2)

        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }

    func googleMapsBuildARouteFromPoint(lat: Float, lng: Float, name: String) {

        let latitude: CLLocationDegrees = CLLocationDegrees(lat)
        let longitude: CLLocationDegrees = CLLocationDegrees(lng)

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name

        if !mapItem.openInMaps(launchOptions: options) {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
            {
                UIApplication.shared.openURL(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(lat),\(lng)")! as URL)
            } else {
                print("Can't use com.google.maps://");
            }
        }
    }

    func getCurrentLanguage() -> String {
        var currentLang = "en"
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String {
            currentLang = lang
        }

        return currentLang
    }
}
