//
//  MyTaskModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 25/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation

protocol MyTaskViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [[String: Any]])
    
}

class MyTaskModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: MyTaskViewControllerDelegate?
    
    
    //MARK: Methods
    func setUserGeoLocation (status: String?) {
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
                self.fetchMyTask(status: status ?? "ACCEPTED")
            default:
                print("No result")
            }
        }
        
        
    }
    
    
    private func fetchMyTask(status: String?) {

        apiRequestManager.getMyOrderFeed(status: status ?? "ACCEPTED"){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                if let _data = data {
                    self.delegate?.updateInformation(data: _data)
                }
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
                case "500004":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Code500004".localized(param: code))
                case "500008":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.NeedVerification".localized(param: code))
                    
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
