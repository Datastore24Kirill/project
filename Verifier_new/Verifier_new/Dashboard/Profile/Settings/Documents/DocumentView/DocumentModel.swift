//
//  DocumentModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol DocumentModelDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: URL)
    
}

class DocumentModel {
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: DocumentModelDelegate?
    
    
    func getUserContractDownload(documentId: Int, documentType: String){
        
        apiRequestManager.getUserDocumentDownload(documentId: documentId, documentType: documentType){ (data, result) in
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

