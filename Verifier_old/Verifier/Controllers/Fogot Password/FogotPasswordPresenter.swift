//
//  FogotPasswordPresenter.swift
//  Verifier
//
//  Created by Кирилл on 16/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol FogotPasswordPresenterOutput: class {
    func presentPreviousVC()
}

class FogotPasswordPresenter: FogotPasswordViewControllerOutput, FogotPasswordInteractorOutput {
    weak var viewController: FogotPasswordViewController!
    weak var view: FogotPasswordViewControllerInput!
    var interactor: FogotPasswordInteractorInput!
    var router: FogotPasswordPresenterOutput!
    
    func didSendPassword(emailOrId: String) {
        interactor.didSendPassword(emailOrId: emailOrId)
    }
    
    func showResultSendPassword() {
        view.showResultSendPassword()
    }
    
    
    func showAlertError(with title: String?, message: String?) {
        signInViewHideSpinner()
        view.showAlertError(with: title, message: message)
    }
    
    func signInViewHideSpinner() {
        view.signInViewHideSpinner()
    }
    
    func presentPreviousVC() {
        router.presentPreviousVC()
    }
    
}
