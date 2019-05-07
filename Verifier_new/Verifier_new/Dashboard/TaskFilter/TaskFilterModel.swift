//
//  TaskFilterModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol TaskFilterModelDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [String: Any])
    func updateInformationOfOrderType(data: [[String: Any]])
    
}

class TaskFilterModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: TaskFilterModelDelegate?

    func getOrderLevel(){
        apiRequestManager.getOrderFilterData(){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
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
    
    func getOrderTypeCategory(){
        apiRequestManager.getContentList(){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                if let _data = data {
                    self.delegate?.updateInformationOfOrderType(data: _data)
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
