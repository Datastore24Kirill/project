//
//  TaskInfoModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 22/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit


protocol TaskInfoViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: [String: Any])
    func getOrderStep(isMyTask: Bool)
    func updateInformationStepList(data: [[String: Any]], orderAccept: Bool)
    
}

class TaskInfoModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: TaskInfoViewControllerDelegate?
    
    func getOrder(orderId: String) {
        apiRequestManager.getOrder(id: orderId){ (data, result) in
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
    
    func getOrderStepList(orderId: String, orderAccept: Bool) {
        apiRequestManager.getOrderStepList(id: orderId){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                if let _data = data {
                    self.delegate?.updateInformationStepList(data: _data, orderAccept: orderAccept)
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
    
    
    
    func orderAccept(orderId: String) {
        apiRequestManager.orderAccept(id: orderId){ (_, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                self.delegate?.getOrderStep(isMyTask: false)
                
            case .failed(let code), .serverError(let code):
                print("ERROR \(code)")
                switch code {
                case "500008":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.NeedVerification".localized(param: code))
                case "500004":
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.Code500004".localized(param: code))
                    
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
