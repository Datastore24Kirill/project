//
//  SignInPresenter.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SignInPresenterOutput: class {
    func presentQRCodeVC()
    func didOpenDashboardVC()
    func didOpenSignUpVC()
    func didOpenForgotPasswordVC()
    func didOpenEnterPasswordVC ()
    func didPresentEmailVerificationVC(email: String)
    
    
}

class SignInPresenter: SignInViewControllerOutput, SignInInteractorOutput {
    
    var router: SignInPresenterOutput!
    weak var view: SignInViewControllerInput!
    var interactor: SignInInteractorInput!
    
    func didLogin(emailOrId: String, password: String) {
        interactor.didLogin(emailOrId: emailOrId, password: password)
    }
    
    func presentDashboardVC() {
        router.didOpenDashboardVC()
    }
    
    func presentSignUpVC() {
        router.didOpenSignUpVC()
    }
    
    func presentFogotPassword() {
        router.didOpenForgotPasswordVC()
    }
    
    func presentEnterPassword() {
        router.didOpenEnterPasswordVC()
    }
    
    func didLoginFB() {
        interactor.didLoginFB()
    }
    
    
    func showAlertError(with title: String?, message: String?) {
        signInViewHideSpinner()
        view.showAlertError(with: title, message: message)
    }
    
    func signInViewHideSpinner() {
        view.signInViewHideSpinner()
    }
    
    func presentQRCodeVC() {
        router.presentQRCodeVC()
    }
    
    func presentEmailVerificationVC(email: String){
        router.didPresentEmailVerificationVC(email: email)
    }
}
