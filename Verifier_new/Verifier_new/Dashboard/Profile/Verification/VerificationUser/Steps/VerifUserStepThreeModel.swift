//
//  VerifUserStepThreeModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 15/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol VerifUserStepModelDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updatePhoto(link: String, image: UIImage, fieldId: Int)

    
}

class VerifUserStepModel {
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: VerifUserStepModelDelegate?
    
    func uploadPhoto(image: UIImage, fieldId: Int) {
        apiRequestManager.attachFile(with: image){ result in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success(_, let link):
                print("OK \(link)")
                self.delegate?.updatePhoto(link: link, image: image, fieldId: fieldId)
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
