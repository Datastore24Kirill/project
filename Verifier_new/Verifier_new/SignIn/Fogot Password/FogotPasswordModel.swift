//
//  FogotPasswordModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

protocol FogotPasswordControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func didShowFogotPasswordPopUp()
    func didShowChangePasswordPopUp()
    func hideSpinnerView()
}

class FogotPasswordModel {
    
    var apiRequestManager = RequestHendler()
    
    // MARK:- Delegate
    weak var delegate: FogotPasswordControllerDelegate?
    
    func didFogotPassword(email:String) {
        
        let parametrs = ["email" : email]
        
        self.apiRequestManager.verifierResetPassword(parameters: parametrs){ (statusCode, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
               self.delegate?.didShowFogotPasswordPopUp()
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
                case "4004001":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Code4004001".localized())
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
    
    func didResetPassword(oldPassword:String, newPassword:String) {
        
        let parametrs = ["oldPassword" : oldPassword, "newPassword" : newPassword]
        print("PARAMS \(parametrs)")
        self.apiRequestManager.verifierChangePassword(parameters: parametrs){ (statusCode, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                self.delegate?.didShowChangePasswordPopUp()
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
                case "403007":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Code403007".localized())
                
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
