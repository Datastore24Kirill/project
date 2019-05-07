//
//  ChangePasswordModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol ChangePasswordViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func didShowChangePasswordPopUp()
}

class ChangePasswordModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: ChangePasswordViewControllerDelegate?
    
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


