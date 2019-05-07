//
//  SignUpPresenter.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SignUpPresenterOutput: class {
    func didOpenSignUpStepTwoVC(user: User)
    func didOpenDashboardVC()
    func presentQRCodeVC()
    func presentPreviousVC()
}

class SignUpPresenter: SignUpViewControllerOutput, SignUpInteractorOutput {
    
    
    var router: SignUpPresenterOutput!
    weak var view: SignUpViewControllerInput!
    var interactor: SignUpInteractorInput!
    
    func presentSignUpStepTwoViewController(user: User) {
        router.didOpenSignUpStepTwoVC(user: user)
    }
    
    func showAlertError(with title: String?, message: String?) {
        view.showAlertError(with: title, message: message)
    }
    
    func presentDashboardVC() {
        router.didOpenDashboardVC()
    }
    
    func signUpViewHideSpinner() {
        view.signInViewHideSpinner()
    }
    

    
    func presentQRCodeVC() {
        router.presentQRCodeVC()
    }
    
    func presentPreviousVC() {
        router.presentPreviousVC()
    }
}
