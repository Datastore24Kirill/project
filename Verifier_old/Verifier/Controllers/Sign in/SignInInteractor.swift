//
//  SignInInteractor.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol SignInInteractorInput: class {
    func didLogin(emailOrId: String, password: String)
    func didLoginFB()
}

protocol SignInInteractorOutput: class {
    func showAlertError(with title: String?, message: String?)
    func presentDashboardVC()
    func presentEmailVerificationVC(email: String)
    func signInViewHideSpinner()
    func presentEnterPassword()
}

class SignInInteractor: SignInInteractorInput {
    
    
    weak var presenter: SignInInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    
    //MARK: Methods
    
    func didLogin(emailOrId: String, password: String) {
        print("Start Login")
        let parameters = [ "login": emailOrId, "password": password, "device": "APPLE" ]
        self.apiRequestManager.verifierLogin(parameters: parameters) { [weak self] in
            
            let isTempPassword = $0 ?? "false"
            if let token = $1 {
                UserDefaultsVerifier.setToken(with: token)
                self?.sendPushToken()
            }
            print("ERROR")
            self?.handlingRequest(with: $2, isTempPassword: isTempPassword, email: emailOrId)
        }
    }
    
    func didLoginFB() {
        SocialNetworksManager.shared.didLoginFB { [weak self] (result) in
            self?.handlingRequest(with: result, isTempPassword: "false", email:"")
        }
    }
    
   
    func sendPushToken() {
        
        let parametrs = ["pushToken": UserDefaultsVerifier.getPushToken()]
        self.apiRequestManager.push(parameters: parametrs) {
            switch $0 {
            case .success:
                print("--> Token Send")
            case .failed, .serverError:
                print("ERROR")
            case .noInternet:
                let title = "InternetErrorTitle".localized()
                let message = "InternetErrorMessage".localized()
                self.presenter.showAlertError(with: title, message: message)
            default:
               print ("error")
                
            }
        }
        
    }
    
    
    private func handlingRequest(with result: ResponseResult, isTempPassword: String, email: String)  {
        print("RESULT \(result)")
        
        switch result {
        case .success:
            if isTempPassword == "true" {
                self.presenter.presentEnterPassword()
            }else{
                self.presenter.presentDashboardVC()
            }
            
        case .failed(let code), .serverError(let code):
            print("CODE \(code)")
            if code == "4004006" {
                self.presenter.presentEmailVerificationVC(email: email)
            }else if code == "4004001" {
                let title = "InternetErrorTitle".localized()
                let message = "Не верный логин или пароль".localized()
                self.presenter.showAlertError(with: title, message: message)
            } else {
                let title = "InternetErrorTitle".localized()
                let message = "Ошибка авторизации. Обратитесь к администратору".localized()
                self.presenter.showAlertError(with: title, message: message)
                print("SignInFail")
            }
            
        case .noInternet:
            let title = "InternetErrorTitle".localized()
            let message = "InternetErrorMessage".localized()
            self.presenter.showAlertError(with: title, message: message)
        default:
            presenter.signInViewHideSpinner()
        }
    }
    
}
