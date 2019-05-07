//
//  ProfileModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 17/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [String: Any])
    
}

class ProfileModel {

    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: ProfileViewControllerDelegate?
    
    func getVerifierUserInfo(){
        
        apiRequestManager.getVerifierUser(){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                print("DATA \(String(describing: data))")
                if let _data = data {
                    self.delegate?.updateInformation(data: _data)
                }
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
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
