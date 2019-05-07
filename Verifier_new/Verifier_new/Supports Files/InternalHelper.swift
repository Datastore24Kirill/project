//
//  InternalHelper.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
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
        case splashScreen
        case signIn
        case signUp
        case dashboard
        case verificationChat
        case verificationUser
        case jivoSite
        case instruction
    
      
        
        func getStoryboard() -> UIStoryboard {
            switch self {
            case .splashScreen:
                return UIStoryboard(name: "SplashScreen", bundle: nil)
            case .signIn:
                return UIStoryboard(name: "SignIn", bundle: nil)
            case .signUp:
                return UIStoryboard(name: "SignUp", bundle: nil)
            case .dashboard:
                return UIStoryboard(name: "Dashboard", bundle: nil)
                
            case .verificationChat:
                return UIStoryboard(name: "VerificationChat", bundle: nil)
            case .verificationUser:
                return UIStoryboard(name: "VerificationUser", bundle: nil)
            case .jivoSite:
                return UIStoryboard(name: "JivoSite", bundle: nil)
            case .instruction:
                return UIStoryboard(name: "Instruction", bundle: nil)
            
            }
            
            
            
        }
        
        func getViewControllerIdentifier()->String {
            return ""
        }
    }
    
    func normalizedImage(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImage.Orientation.up) {
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
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
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
                UIApplication.shared.open(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(lat),\(lng)")! as URL, options: [:], completionHandler: nil)
                
            } else {
                print("Can't use com.google.maps://");
            }
        }
    }
    
    func getCurrentLanguage() -> String {
        var currentLang = "ru"
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String {
            currentLang = lang
        }
        
        return currentLang
    }
}
