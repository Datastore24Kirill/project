//
//  NotificationModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

protocol NotificationModelDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateBadges(data: [String: Any])
    func updateInformation(data: [[String: Any]])
    
}

extension NotificationModelDelegate {
    func updateBadges(data: [String: Any]){}
    func updateInformation(data: [[String: Any]]){}
    func notificationReadUpdate(){}
}


class NotificationModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: NotificationModelDelegate?
    
    func getBadges() {
        apiRequestManager.getBadges(){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                print("DATA \(String(describing: data))")
                if let _data = data {
                    self.delegate?.updateBadges(data: _data)
                }
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
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
    
    func fetchNotification(){
        apiRequestManager.notificationList(start: 0, count: 0){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                print("DATA \(String(describing: data))")
                if let _data = data {
                    self.delegate?.updateInformation(data: _data)
                }
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
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
    
    func notificationRead(notificationId: Int) {
        
        let params = ["notificationId" : [notificationId]]
        
        apiRequestManager.notificationRead(params: params){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
               self.fetchNotification()
               
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
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
    
    func notificationAllRead() {
        
        
        apiRequestManager.notificationAllRead{ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                self.fetchNotification()
                
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
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
