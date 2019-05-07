//
//  FeedBackModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol FeedBackViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    
}


class FeedBackModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: FeedBackViewControllerDelegate?
    
    func sendFeedBack(name: String, text: String ) {
        apiRequestManager.sendFeedBack(name: name, text: text) { (statusCode, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                self.delegate?.showAlertError(with: "FeedBackPopUp.Title".localized(), message: "FeedBackPopUp.Msg".localized())
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
