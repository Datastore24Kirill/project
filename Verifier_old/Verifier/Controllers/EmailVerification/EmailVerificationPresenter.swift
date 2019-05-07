//
//  EmailVerificationPresenter.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 21/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol EmailVerificationPresenterOutput: class {
    
    func presentLoginVC()
    func presentResendEmailVerifiaction()
}


class EmailVerificationPresenter: EmailVerificationViewControllerOutput, EmailVerificationInteractorOutput {
    
    var router: EmailVerificationPresenterOutput!
    weak var view: EmailVerificationViewControllerInput!
    var interactor: EmailVerificationInteractorInput!
   
    
    func presentLoginVC() {
        router.presentLoginVC()
    }
    
    func didResendVerifierEmail(with emailString: String?) {
        if let tempEmail = emailString {
            interactor.didResendVerifierEmail(with: tempEmail)
            
        } else {
            showAlertError(with: "Ошибка", message: "Ошибка, обратитесь к администратору")
        }
        
    }
    
    func showTextForAlredySendEmail () {
        router.presentResendEmailVerifiaction()
    }
    
    func showAlertError(with title: String?, message: String?) {
        hideSpinner()
        view.showAlertError(with: title, message: message)
    }
    
    func hideSpinner() {
        view.emailHideSpinner()
    }
    
}
