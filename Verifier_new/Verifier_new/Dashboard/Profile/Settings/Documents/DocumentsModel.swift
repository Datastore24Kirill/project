//
//  DocumentsModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol DocumentsModelDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [[String: Any]])
    
}

class DocumentsModel {
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: DocumentsModelDelegate?
    
    
    func getUserContractList(){
        
        apiRequestManager.getUserDocumentsList(){ (data, result) in
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

