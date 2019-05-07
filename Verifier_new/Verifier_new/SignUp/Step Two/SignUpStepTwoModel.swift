//
//  SignUpStepTwoModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

protocol SignUpStepTwoModelDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func didShowStepFinal()
}


class SignUpStepTwoModel {
    var apiRequestManager = RequestHendler()
    
    // MARK:- Delegate
    weak var delegate: SignUpStepTwoModelDelegate?
    
    func didRegisterVerifier (parametrs: [String:String]) {
        self.apiRequestManager.verifierRegistration(parameters: parametrs){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                self.delegate?.didShowStepFinal()
            case .failed(let code), .serverError(let code):
                print("ERROR")
                switch code {
                    case "403002":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Code403002".localized())
                default:
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.CodeShow".localized(param: code))
                }
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
