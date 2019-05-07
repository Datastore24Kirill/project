//
//  EmailVerificationInteractor.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 21/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol EmailVerificationInteractorInput: class {
    func didShowLoginVc()
    func didResendVerifierEmail(with emailString: String?)
}

protocol EmailVerificationInteractorOutput: class {
    
    func presentLoginVC()
    
    func showAlertError(with title: String?, message: String?)
    func showTextForAlredySendEmail ()
    
}

class EmailVerificationInteractor: EmailVerificationInteractorInput {
    
    weak var presenter: EmailVerificationInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func didShowLoginVc() {
        
        self.presenter.presentLoginVC()
        
        
    }
    
    func didResendVerifierEmail(with emailString: String?) {
        
        var parametrs = [String : String]()
        if let tempEmail = emailString {
            parametrs = ["email": tempEmail]
        } else {
            parametrs = ["email": ""]
        }
        
        
        self.apiRequestManager.resendVerifierEmail(parameters: parametrs) {
            switch $0 {
            case .success:
                print("--> RESEND")
                self.presenter.showTextForAlredySendEmail()
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
    
}
