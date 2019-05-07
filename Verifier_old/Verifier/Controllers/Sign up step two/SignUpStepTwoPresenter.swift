//
//  SignUpStepTwoPresenter.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SignUpStepTwoPresenterOutput: class {
    func didOpenDashboardVC(email: String)
    func didOpenDashboardWithOutPromo()
    func presentPreviousVC()
}

class SignUpStepTwoPresenter: SignUpStepTwoViewControllerOutput, SignUpStepTwoInteractorOutput {
    
    var router: SignUpStepTwoPresenterOutput!
    weak var view: SignUpStepTwoViewControllerInput!
    var interactor: SignUpStepTwoInteractorInput!
    
    func didRegistration(with user: User) {
        interactor.didRegistration(with: user)
    }
    
    func didResetPassword(with user: User) {
        interactor.didResetPassword(with: user)
    }
    
    func showAlertError(with title: String?, message: String?) {
        signUpStepTwoViewHideSpinner()
        view.showAlertError(with: title, message: message)
    }
    
    func presentDashboardVC(email: String) {
        router.didOpenDashboardVC(email: email)
    }
    
    func presentDashboeardWithOutPromo() {
        router.didOpenDashboardWithOutPromo()
    }
    
    func signUpStepTwoViewHideSpinner() {
        view.signUpStepTwoViewHideSpinner()
    }
    
    func presentPreviousVC() {
        router.presentPreviousVC()
    }
}
