//
//  AllTaskModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation
import GoogleMaps


protocol AllTaskViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [[String: Any]])
    
}


class AllTaskModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: AllTaskViewControllerDelegate?
    
    struct OrderFeedParameters {
        var start = "0"
        var count = "0"
    }
    
    //MARK: Methods
    func setUserGeoLocation () {
        guard let lat = LocationManager.share.currentLocation?.latitude,
            let lng = LocationManager.share.currentLocation?.longitude else {
                self.delegate?.showAlertError(with: "Error".localized(), message: "Error.GeoLocation".localized())
                self.delegate?.hideSpinnerView()
                return
        }
        
        GoogleManager.getAddressByCoordinate(with: LocationManager.share.currentLocation!) { (name) in
            print("ADDRESS: \(name) lat \(lat) \(lng)")
        }
        
        self.apiRequestManager.setUserLocation(
        parameters: ["latitude": lat, "longitude": lng]) { (res) in
            self.delegate?.hideSpinnerView()
            switch res {
            case .success:
                print("Ok set Location")
                self.provideTasks()
            default:
                print("No result")
            }
        }
        
        
    }
    

    
    private func provideTasks() {
        
        apiRequestManager.getOrderFeed(start: 0, count: 0){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
               
                if let _data = data {
                    self.delegate?.updateInformation(data: _data)
                }
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
                case "500008":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.NeedVerification".localized(param: code))
                case "500004":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Code500004".localized(param: code))
                    
                default:
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.CodeShow".localized(param: code))
                }
            case .noInternet:
                let title = "Error".localized()
                let message = "Error.Server".localized()
                self.delegate?.showAlertError(with: title, message: message)
            default:
                print ("error")
                
            }
            
            
        }
    }
    
}
