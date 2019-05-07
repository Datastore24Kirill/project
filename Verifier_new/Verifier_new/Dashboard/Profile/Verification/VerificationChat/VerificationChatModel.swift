//
//  VerificationChatModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 27/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol VerificationChatViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [[String: Any]])
    
}

class VerificationChatModel {
    
    var apiRequestManager = RequestHendler()
    
     weak var delegate: VerificationChatViewControllerDelegate?
    
    func getDialog(branch: String?) {
 
        let branchToLoad = branch ?? "start"
   
        apiRequestManager.branchChat(branch: branchToLoad) { (data, result) in
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
