//
//  TaskStepModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol TaskStepViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformation(data: String)
    func loadNextStep()
    func showLastStep()
    func didShowPreviousViewController()
    func updatePhoto(link: String, image: UIImage, indexPath: IndexPath?, section: Int?)
    func updateVideo(link:String, url: URL, video: Data, indexPath: IndexPath?, section: Int?)
    
}

class TaskStepModel {
    
    var apiRequestManager = RequestHendler()
    
    //MARK: - DELEGATE
    weak var delegate: TaskStepViewControllerDelegate?
    
    let resultTaskStepRealm = RealmSwiftTaskStepListAction.listRealm()
    
    func getOrderStep(orderId: String, taskStepIndex: String) {
        
        
        let taskStepInfo = resultTaskStepRealm.filter("taskId = \(orderId) AND taskStepIndex = \(taskStepIndex)").first
        if taskStepInfo != nil {
            delegate?.updateInformation(data: taskStepInfo!.taskStep ?? "")
        } else {
            self.delegate?.showAlertError(with: "Error".localized(), message: "Error.LoadStepError".localized())
        }
//
//        apiRequestManager.getOrderStep(id: orderId){ (data, result) in
//            self.delegate?.hideSpinnerView()
//            switch result {
//            case .success:
//
//                if let _data = data, _data.count > 0 {
//                    self.delegate?.updateInformation(data: _data)
//                } else {
//                  self.delegate?.showAlertError(with: "Error".localized(), message: "Error.LoadStepError".localized())
//                }
//
//            case .failed(let code), .serverError(let code):
//                print("ERROR \(code)")
//                switch code {
//                default:
//                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.CodeShow".localized(param: code))
//                }
//            case .noInternet:
//                let title = "Error".localized()
//                let message = "Error.Server".localized()
//                self.delegate?.showAlertError(with: title, message: message)
//            default:
//                print ("error")
//
//            }
        
            
//        }
    }
    
    
    
    func orderStepTask(params:[String : Any], orderId: String, taskStepIndex: String) {
        print(params)
        
        
//        apiRequestManager.orderStepData(params: params){ (data, result) in
//            self.delegate?.hideSpinnerView()
//            switch result {
//            case .success:
//
//                if let _data = data,
//                    let isLastStep = _data["isLastStep"] as? Int{
//                    switch isLastStep {
//                    case 0: self.delegate?.loadNextStep()
//                    case 1: self.delegate?.showLastStep()
//                    default: break
//                    }
//                }
//
//            case .failed(let code), .serverError(let code):
//                print("ERROR \(code)")
//                switch code {
//                default:
//                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.CodeShow".localized(param: code))
//                }
//            case .noInternet:
//                let title = "Error".localized()
//                let message = "Error.Server".localized()
//                self.delegate?.showAlertError(with: title, message: message)
//            default:
//                print ("error")
//
//            }
//
//
//        }
    }
    
    func orderRate(params:[String : Any]) {
        
        apiRequestManager.orderRate(params: params){ (data, result) in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                
                self.delegate?.didShowPreviousViewController()
                
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
    
    func uploadPhoto(image: UIImage, indexPath: IndexPath?, section: Int?) {
        apiRequestManager.attachFile(with: image){ result in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success(_, let link):
                print("OK \(link)")
                self.delegate?.updatePhoto(link: link, image: image, indexPath: indexPath, section: section)
//                self.delegate?.updatePhoto(link: link, image: image, fieldId: fieldId, section: <#Int?#>)
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
    
    func uploadVideo(url: URL, video: Data, indexPath: IndexPath?, section: Int?) {
        
        apiRequestManager.attachFile(video: video){ result in
            self.delegate?.hideSpinnerView()
            switch result {
            case .success(_, let link):
                print("OK \(link)")
                self.delegate?.updateVideo(link: link, url: url, video: video, indexPath: indexPath, section: section)
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
