//
//  FogotPasswordInteractor.swift
//  Verifier
//
//  Created by Кирилл on 16/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol FogotPasswordInteractorInput: class {
    func didSendPassword(emailOrId: String)
}

protocol FogotPasswordInteractorOutput: class {
    func showAlertError(with title: String?, message: String?)
    func showResultSendPassword()
    func signInViewHideSpinner()
}

class FogotPasswordInteractor: FogotPasswordInteractorInput {

    
    weak var presenter: FogotPasswordInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    //MARK: Methods
    
    func didSendPassword(emailOrId: String) {
        print("Start Fogot Password")
        let parameters = ["email": emailOrId]
        self.apiRequestManager.verifierResetPassword(parameters: parameters) { [weak self] in
            self?.handlingRequest(with: $1)
        }
    }
    
    
    private func handlingRequest(with result: ResponseResult)  {
        switch result {
        case .success:
            
            self.presenter.showResultSendPassword()
        case .failed, .serverError:
            self.presenter.showAlertError(with: "LoginErrorTitle".localized(), message: "LoginErrorDescription".localized())
        case .noInternet:
            let title = "InternetErrorTitle".localized()
            let message = "FogotPassword.Message.Error.Server".localized()
            self.presenter.showAlertError(with: title, message: message)
        default:
            presenter.signInViewHideSpinner()
        }
    }
    
}

