//
//  SignUpStepTwoInteractor.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol SignUpStepTwoInteractorInput: class {
    func didRegistration(with user: User)
    func didResetPassword(with user: User)
}

protocol SignUpStepTwoInteractorOutput: class {
    func showAlertError(with title: String?, message: String?)
    func presentDashboardVC(email: String)
    func presentDashboeardWithOutPromo()
    func signUpStepTwoViewHideSpinner()
}

class SignUpStepTwoInteractor: SignUpStepTwoInteractorInput {
    
    weak var presenter: SignUpStepTwoInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func didRegistration(with user: User) {
        
        var parameters = [String: String]()
        print("USERTOSEND: \(user)")
        if let value = user.email {
            parameters.updateValue(value, forKey: "email")
        }
        
        if let value = user.password {
            parameters.updateValue(value, forKey: "password")
        }
        
        if let value = user.firstName {
            parameters.updateValue(value, forKey: "firstName")
        }
        
        if let value = user.lastName {
            parameters.updateValue(value, forKey: "lastName")
        }
        
        if let value = user.promocode {
            if value != "" {
                parameters.updateValue(value, forKey: "promoCode")
            }
        }
        
        print("PARAMETRS \(parameters)")
        
        self.apiRequestManager.verifierRegistration(parameters: parameters) {
            
//            if let token = $0 {
//                UserDefaultsVerifier.setToken(with: token)
//            }
            switch $1 {
            case .success:
                if let email = parameters["email"] {
                    self.presenter.presentDashboardVC(email:email)
                } else {
                    self.presenter.presentDashboardVC(email:"")
                }
             
            case .failed(let code), .serverError(let code):
                print("CODE \(code)")
                if code == "403002" {
                    let title = "InternetErrorTitle".localized()
                    let message = "Пользователь с таким email уже зарегистрирован"
                    self.presenter.showAlertError(with: title, message: message)
                } else {
                    let title = "InternetErrorTitle".localized()
                    let message = "Ошибка регистрации. Обратитесь к администратору КОД \(code)"
                    self.presenter.showAlertError(with: title, message: message)
                    print("SignInFail")
                }
            case .noInternet:
                let title = "InternetErrorTitle".localized()
                let message = "InternetErrorMessage".localized()
                self.presenter.showAlertError(with: title, message: message)
            default:
                self.presenter.signUpStepTwoViewHideSpinner()
            }
        }
    }
    
    func didResetPassword(with user: User) {
        
        var parameters = [String: String]()
        
        if let value = user.email {
            parameters.updateValue(value, forKey: "email")
        }
        
        if let value = user.password {
            parameters.updateValue(value, forKey: "password")
        }
        
        if let value = user.firstName {
            parameters.updateValue(value, forKey: "firstName")
        }
        
        if let value = user.lastName {
            parameters.updateValue(value, forKey: "lastName")
        }
        
        if let value = user.promocode {
            if value != "" {
                parameters.updateValue(value, forKey: "promoCode")
            }
        }
        
        self.apiRequestManager.verifierUpdate(parameters: parameters) {
            print("RESET PASSWORD \($0)")
            switch $0 {
            case .success:
                self.presenter.presentDashboeardWithOutPromo()
            case .failed, .serverError:
                self.presenter.showAlertError(with: "LoginErrorTitle".localized(), message: "LoginErrorDescription".localized())
            case .noInternet:
                let title = "InternetErrorTitle".localized()
                let message = "InternetErrorMessage".localized()
                self.presenter.showAlertError(with: title, message: message)
            default:
                self.presenter.signUpStepTwoViewHideSpinner()
            }
        }
    }
    
}
