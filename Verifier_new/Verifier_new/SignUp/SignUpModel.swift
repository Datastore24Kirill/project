//
//  SignUpModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit


protocol SignUpViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func didShowEmailVerificationPopUp (confirmationEmail: String)
    func didShowEmailVerificationAlredySendPopUp (confirmationEmail: String)
    func hideSpinnerView()
    func showSpinnerView()
}


class SignUpModel {
    
    var apiRequestManager = RequestHendler()
    
    var emailTemp:String?
    var fbIdTemp:String?
    var vkIdTemp:String?
    var nicknameTemp:String?
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    // MARK:- Delegate
    weak var delegate: SignUpViewControllerDelegate?
    
 
    
    func didLoginFB(email: String, fbId: String, nickname: String) {
        self.delegate?.showSpinnerView()
        let parametrs = ["email":email, "fbId":fbId,  "device":"APPLE", "nickname" : nickname]
        
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
                    if let confirmation = dict["confirmationHasBeenSentTo"] as? String,
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
    
    func didLoginVK(email: String, vkId: String, nickname: String) {
        self.delegate?.showSpinnerView()
        let parametrs = ["email":email, "vkId":vkId,  "device":"APPLE", "nickname" : nickname]
        
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
                    if let confirmation = dict["confirmationHasBeenSentTo"] as? String,
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
                            break
                        case 1:
                            self.delegate?.didShowEmailVerificationPopUp(confirmationEmail: emailString)
                        case 2:
                            if let email = self.emailTemp,
                                let vkId = self.vkIdTemp,
                                let nickname = self.nicknameTemp {
                                self.didLoginVK(email: email, vkId: vkId, nickname: nickname)
                            } else if let email = self.emailTemp,
                                let fbId = self.fbIdTemp,
                                let nickname = self.nicknameTemp {
                                self.didLoginFB(email: email, fbId: fbId, nickname: nickname)
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
