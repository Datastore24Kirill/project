//
//  ProfileEditModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 20/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol ProfileEditViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updatePhoto(link: String, image: UIImage)
}

class ProfileEditModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: ProfileEditViewControllerDelegate?
    
    
    func updateVerifier(params: [String:Any]) {
        
        apiRequestManager.verifierUpdate(parameters: params){ result in
            
            self.delegate?.hideSpinnerView()
            print("DICT \(result)")
            switch result {
            case .success:
                print("OK")
                 self.delegate?.showAlertError(with: "ProfileEditOk.Title".localized(), message: "ProfileEditOk.Msg".localized())
            case .failed(let code), .serverError(let code):
                print("ERROR")
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
    
    func uploadAvatar(image: UIImage) {
        apiRequestManager.attachFile(with: image){ result in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success(_, let link):
                print("OK \(link)")
                self.delegate?.updatePhoto(link: link, image: image)
            case .serverError:
                print("ERROR")
                
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
