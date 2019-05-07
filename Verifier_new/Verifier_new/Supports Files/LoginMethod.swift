//
//  LoginMethod.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol LoginMethodDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func didShowEmailVerificationPopUp (confirmationEmail: String)
    func didShowEmailVerificationAlredySendPopUp (confirmationEmail: String)
    func didShowResetPasswordViewController()
    func didShowSocialPassword()
    func showSpinnerView()
}

extension LoginMethodDelegate {
    
    func didShowEmailVerificationPopUp (confirmationEmail: String) {}
    func didShowEmailVerificationAlredySendPopUp (confirmationEmail: String) {}
    func didShowResetPasswordViewController() {}
    func didShowSocialPassword() {}
    
    
}

class LoginMethod{
    
    //MARK: - PROPERTIES
    var apiRequestManager = RequestHendler()
    var emailTemp:String?
    var passwordTemp:String?
    var fbIdTemp:String?
    var vkIdTemp:String?
    var nicknameTemp:String?
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    // MARK:- Delegate
    weak var delegate: LoginMethodDelegate?
    
    
    func didLogin(email: String, password: String) {
        
        let parameters = [ "login": email, "password": password, "device": "APPLE" ]
        
        emailTemp = email
        passwordTemp = password
        
        self.apiRequestManager.verifierLogin(parameters: parameters) {(data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                if let dict = data {
                    print("DICT \(dict)")
                    if let isTempPassword = dict["isTempPassword"] as? String,
                        isTempPassword == "true",
                        let token = dict["token"] as? String{
                        print("TEMP PASSWORD")
                        
                        RealmSwiftAction.updateRealm(verifierId: nil, enterToken: token, pushToken: nil, isFirstLaunch: nil)
                        self.delegate?.didShowResetPasswordViewController()
                        
                    } else if let token = dict["token"] as? String,
                        let verificationStatus = dict ["verificationStatus"] as? Int{
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
                        
                        print("LOGIN EMAIL OK")
                    }
                    
                }
                
            case .failed(let code), .serverError(let code):
                print("CODE \(code)")
                if code == "4004006" {
                    self.delegate?.didShowEmailVerificationPopUp(confirmationEmail: email)
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
    
    func didLoginFB(email: String, fbId: String, nickname: String, password: String?) {
        self.delegate?.showSpinnerView()
        var parametrs = ["email":email, "fbId":fbId,  "device":"APPLE", "nickname" : nickname]
        if let pass = password {
            parametrs["password"] = pass
        }
        
        emailTemp = email
        fbIdTemp = fbId
        nicknameTemp = nickname
        
        print("LOGIN FB PARAMS -> \(parametrs)")
        apiRequestManager.verifierLoginFB(parameters: parametrs) {(data, result) in
            
            //            self.viewController.showAlertError(with: title, message: message)
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                if let dict = data {
                    print("DICT \(dict)")
                    if let isNeedPassword = dict["isNeedPassword"] as? Int,
                        isNeedPassword == 1{
                        self.delegate?.didShowSocialPassword()
                    }else if let confirmation = dict["confirmationHasBeenSentTo"] as? String,
                        confirmation.count>0{
                        self.delegate?.didShowEmailVerificationPopUp(confirmationEmail: confirmation)
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
                print("--> Token Send")
            case .failed(let code), .serverError(let code):
                print("ERROR")
                switch code{
                case "400002":
                    self.delegate?.didShowSocialPassword()
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
    
    func didLoginVK(email: String, vkId: String, nickname: String, password: String?) {
        self.delegate?.showSpinnerView()
        var parametrs = ["email":email, "vkId":vkId,  "device":"APPLE", "nickname" : nickname]
        if let pass = password {
            parametrs["password"] = pass
        }
        
        emailTemp = email
        vkIdTemp = vkId
        nicknameTemp = nickname
        
        print("LOGIN VK PARAMS -> \(parametrs)")
        apiRequestManager.verifierLoginVK(parameters: parametrs) {(data, result) in
            
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                if let dict = data {
                    print("DICT \(dict)")
                    if let isNeedPassword = dict["isNeedPassword"] as? Int,
                        isNeedPassword == 1{
                        self.delegate?.didShowSocialPassword()
                    }else if let confirmation = dict["confirmationHasBeenSentTo"] as? String,
                        confirmation.count>0{
                        self.delegate?.didShowEmailVerificationPopUp(confirmationEmail: confirmation)
                    } else if let token = dict["token"] as? String,
                        let verificationStatus = dict ["verificationStatus"] as? Int {
                        RealmSwiftAction.updateRealm(verifierId: nil, enterToken: token, pushToken: nil, isFirstLaunch: nil)
                        print("LOGIN VK OK")
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
                print("ERROR")
                switch code{
                case "400002":
                    self.delegate?.didShowSocialPassword()
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
    
    func didResendVerifierEmail(with emailString: String) {
        let parametrs = ["email": emailString]
        self.apiRequestManager.resendVerifierEmail(parameters: parametrs) {
            self.delegate?.hideSpinnerView()
            switch $0 {
            case .success:
                print("--> RESEND")
                self.delegate?.didShowEmailVerificationAlredySendPopUp(confirmationEmail: emailString)
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
    
    func didCheckVerifierEmail(with emailString: String) {
        let parametrs = ["email": emailString]
        self.apiRequestManager.checkVerifierEmail(parameters: parametrs){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                if let dict = data {
                    print("DICT \(dict)")
                    if let confirmStatus = dict["confirmationStatus"] as? Int {
                        switch confirmStatus {
                        case 0:
                            self.appDelegate?.reloginUser()
                        case 1:
                            self.delegate?.didShowEmailVerificationPopUp(confirmationEmail: emailString)
                        case 2:
                            if let email = self.emailTemp,
                                let password = self.passwordTemp {
                                self.didLogin(email: email, password: password)
                            } else if let email = self.emailTemp,
                                let vkId = self.vkIdTemp,
                                let nickname = self.nicknameTemp {
                                self.didLoginVK(email: email, vkId: vkId, nickname: nickname, password: nil)
                            } else if let email = self.emailTemp,
                                let fbId = self.fbIdTemp,
                                let nickname = self.nicknameTemp {
                                self.didLoginFB(email: email, fbId: fbId, nickname: nickname, password: nil)
                            }
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
}
