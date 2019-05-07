//
//  ProfileInteractor.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileInteractorInput: class {
    func didEditProfile()
    func verifierVerify(verifAddr: String, long: Double, lat: Double, timeTo: Int)
}

protocol ProfileInteractorOutput: class {
    func provideResponseResult(with result: ResponseResult)
    func showProfileViewAlert(with: String, message: String)
}

class ProfileInteractor: ProfileInteractorInput {
    
    weak var presenter: ProfileInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func isValidPassword(with password: String) -> Bool? {
        
        //check repeat password on nil
        guard let repeatPassword = User.sharedInstanse.repeatPassword else {
            if password.trimmingCharacters(in: .whitespaces).count != 0 {
                let message = "ConfirmPasswordErrorMessage".localized()
                presenter.provideResponseResult(with: .failed(message))
                return nil
            } else {
                return false
            }
        
        }
        
        if password.trimmingCharacters(in: .whitespaces).count == 0 && repeatPassword.trimmingCharacters(in: .whitespaces).count == 0 {
            return false
        }
        
        guard password.trimmingCharacters(in: .whitespaces).count > 0 else {
            let message = "PasswordErrorMessage".localized()
            presenter.provideResponseResult(with: .failed(message))
            return nil
        }
        
        guard repeatPassword.count != 0 || repeatPassword != "" else {
            let message = "ConfirmPasswordErrorMessage".localized()
            presenter.provideResponseResult(with: .failed(message))
            return nil
        }
        
        guard password == repeatPassword else {
            let message = "ConfirmAndPasswordErrorMessage".localized()
            presenter.provideResponseResult(with: .failed(message))
            return nil
        }
        
        return true
        
    }
    
    func didEditProfile() {
        
        var parameters = [String: Any]()

        guard User.sharedInstanse.profilePhoto != UIImageJPEGRepresentation(#imageLiteral(resourceName: "verifier_ava"), 1.0) else {
            let message = "add_photo".localized()
            presenter.provideResponseResult(with: .failed(message))
            return
        }
        
        if let email = User.sharedInstanse.email?.trimmingCharacters(in: .whitespaces), email.count > 0 {
            if InternalHelper.sharedInstance.isValidEmail(email: email) {
                parameters.updateValue(email, forKey: "email")
            } else {
                let message = "EmailErrorMessage".localized()
                presenter.provideResponseResult(with: .failed(message))
                return
            }
        }
        
        if let password = User.sharedInstanse.password {
            
            if let res = isValidPassword(with: password) {
                if res {
                    parameters.updateValue(password, forKey: "password")
                }
            } else {
                return
            }
            
        } else if let repeatPassword = User.sharedInstanse.repeatPassword {
                guard repeatPassword.trimmingCharacters(in: .whitespaces).count == 0 else {
                    let message = "PasswordErrorMessage".localized()
                    presenter.provideResponseResult(with: .failed(message))
                    return
                }
        }
        
        if let value = User.sharedInstanse.phone {
            parameters.updateValue(value, forKey: "phone")
        }
        
        if let value = User.sharedInstanse.firstName {
            parameters.updateValue(value, forKey: "firstName")
        }
        
        if let value = User.sharedInstanse.lastName {
            parameters.updateValue(value, forKey: "lastName")
        }
        
        if let value = User.sharedInstanse.birthDate {
            parameters.updateValue(value, forKey: "birthDate")
        }
        
        if let value = User.sharedInstanse.type {
            parameters.updateValue(value, forKey: "type")
        }
        
        if let value = User.sharedInstanse.passportType {
            parameters.updateValue(value, forKey: "passportType")
        }
        
        if let value = User.sharedInstanse.companyName {
            parameters.updateValue(value, forKey: "companyName")
        }
        
        if let value = User.sharedInstanse.passportSeries {
            parameters.updateValue(value, forKey: "passportSeries")
        }
        
        if let value = User.sharedInstanse.passportNumber {
            parameters.updateValue(value, forKey: "passportNumber")
        }
        
        if let value = User.sharedInstanse.issue {
            parameters.updateValue(value, forKey: "issue")
        }
        
        if let value = User.sharedInstanse.issueDate {
            parameters.updateValue(value, forKey: "issueDate")
        }
        
        if let value = User.sharedInstanse.issueCode {
            parameters.updateValue(value, forKey: "issueCode")
        }
        
        if let value = User.sharedInstanse.specialization {
            parameters.updateValue(value, forKey: "specialization")
        }
        
        if let address = User.sharedInstanse.address {
            
            if let value = address.addressType {
                parameters.updateValue(value, forKey: "addressType")
            }
            
            if let value = address.country {
                parameters.updateValue(value, forKey: "addressCountry")
            }
            if let value = address.region {
                parameters.updateValue(value, forKey: "addressRegion")
            }
            
            if let value = address.city {
                parameters.updateValue(value, forKey: "addressCity")
            }
            
            if let value = address.street {
                parameters.updateValue(value, forKey: "addressStreet")
            }
            
            if let value = address.house {
                parameters.updateValue(value, forKey: "addressHouse")
            }
            
            if let value = address.flat {
                parameters.updateValue(value, forKey: "addressFlat")
            }
            if let value = address.zipCode {
                parameters.updateValue(value, forKey: "addressZipCode")
            }
            
        }
        
        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideResponseResult(with: .noInternet)
            return
        }
        
        if parameters.count == 0 && User.sharedInstanse.profilePhoto == nil {
            self.presenter.provideResponseResult(with: .success)
            return
        }
        
        apiRequestManager.verifierUpdate(parameters: parameters) { res in
            self.presenter.provideResponseResult(with: res)
        }
        
    }
    
    func verifierVerify(verifAddr: String, long: Double, lat: Double, timeTo: Int) {
        apiRequestManager.verifierVerify(
            verifAddr: verifAddr,
            long: long,
            lat: lat,
            timeTo: timeTo) { [weak self] (result) in
                switch result {
                case .none:
                    self?.presenter.showProfileViewAlert(
                        with: "InternetErrorTitle".localized(),
                        message: ""
                    )
                case .noInternet:
                    self?.presenter.showProfileViewAlert(
                        with: "InternetErrorTitle".localized(),
                        message: "InternetErrorMessage".localized()
                    )
                case .serverError(let error):
                    self?.presenter.showProfileViewAlert(
                        with: "InternetErrorTitle".localized(),
                        message: error
                    )
                case .success:
                    self?.presenter.showProfileViewAlert(
                        with: "Done".localized(),
                        message: ""
                    )
                case .failed(let error):
                    self?.presenter.showProfileViewAlert(
                        with: "InternetErrorTitle".localized(),
                        message: error
                    )
                }
        }
    }
    
}
