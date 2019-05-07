//
//  StepFinalModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 10/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol StepFinalViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func didShowResetPasswordViewController()
}

class StepFinalModel {
    var apiRequestManager = RequestHendler()
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    weak var delegate: StepFinalViewControllerDelegate?
    
    func didCheckVerifierEmail(with params: [String:String]) {
        guard let email = params["email"],
            let password = params["password"] else {
            self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Server".localized())
            return
        }
        let parametrs = ["email": email]
        self.apiRequestManager.checkVerifierEmail(parameters: parametrs){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                if let dict = data {
                    print("DICT \(dict)")
                    if let confirmStatus = dict["confirmationStatus"] as? Int {
                        switch confirmStatus {
                        case 0:
                            break
                        case 1:
                            self.delegate?.showAlertError(with: "Error".localized(), message: "Error.EmailVerification".localized())
                        case 2:
                            self.didLogin(email: email, password: password)
                        default:
                            break
                        }
                    }
                }
            case .failed, .serverError:
                print("ERROR")
            case .noInternet:
                let title = "Error".localized()
                let message = "Error.Server".localized()
                self.delegate?.showAlertError(with: title, message: message)
            default:
                print ("error")
                
            }
        }
        
    }
    
    
    private  func didLogin(email: String, password: String) {
        
        let parameters = [ "login": email, "password": password, "device": "APPLE" ]
        
        self.apiRequestManager.verifierLogin(parameters: parameters) {(data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                if let dict = data {
                    print("DICT \(dict)")
                    if let isTempPassword = dict["isTempPassword"] as? Bool,
                        isTempPassword == true{
                        print("TEMP PASSWORD")
                        self.delegate?.didShowResetPasswordViewController()
                    } else if let token = dict["token"] as? String,
                        let verificationStatus = dict ["verificationStatus"] as? Int {
                        RealmSwiftAction.updateRealm(verifierId: nil, enterToken: token, pushToken: nil, isFirstLaunch: nil)
                        switch verificationStatus {
                        case 0:
                            
                            self.appDelegate?.showNoVerification()
                            
                        case 1,2:
                            
                            self.appDelegate?.showDashBoard()
                            
                            
                        case 3:
                            
                            self.appDelegate?.showProfile()
                            
                        default:
                            break
                        }
                    }
                }
                
            case .failed(let code), .serverError(let code):
                print("CODE \(code)")
                if code == "4004006" {
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.EmailVerification".localized())
                }else if code == "4004001" {
                    let title = "Error".localized()
                    let message = "Error.Code4004001".localized()
                    self.delegate?.showAlertError(with: title, message: message)
                } else {
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.CodeShow".localized(param: code))
                    print("SignInFail")
                }
                
            case .noInternet:
                let title = "Error".localized()
                let message = "Error.NoInternet".localized()
                self.delegate?.showAlertError(with: title, message: message)
            default:
                print("error")
                
            }
            
        }
        
    }
}


