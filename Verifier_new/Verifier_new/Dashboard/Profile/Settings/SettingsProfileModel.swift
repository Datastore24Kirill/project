//
//  SettingsProfileModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

protocol SettingsProfileViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
}

class SettingsProfileModel {
    
    var apiRequestManager = RequestHendler()
    
    // MARK:- Delegate
    weak var delegate: SettingsProfileViewControllerDelegate?
    
    func logout() {
       
        
        apiRequestManager.verifierLogout(){ result in
           self.delegate?.hideSpinnerView()
            switch result {
            case .success:
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                RealmSwiftAction.updateRealm(verifierId: nil, enterToken: "", pushToken: nil, isFirstLaunch: false)
                appDelegate?.reloginUser()
            case .failed, .serverError:
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
