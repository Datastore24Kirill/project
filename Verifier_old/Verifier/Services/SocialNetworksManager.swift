//
//  SocialNetworksManager.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class SocialNetworksManager {
    
    static let shared = SocialNetworksManager()
    
    private var apiRequestManager: RequestHendler = RequestHendler()
    private var userSocial = ""
    
    private struct UserCodable: Codable {
        let id: Int?
        let login: String?
        let name: String?
        let lastName: String?
        let rating: Double?
        let countStarts: Double?
    }
    
    private init() {
    }
    
    private func didRegistration(with user: User,
                                 _ completion: @escaping (_ result: ResponseResult)->Void) {
        var parameters = [String: String]()
        
        if let value = user.email {
            parameters.updateValue(value, forKey: "email")
        }
        
        if let value = user.password {
            parameters.updateValue(value, forKey: "password")
        }
        
        if let value = user.firstName {
            parameters.updateValue(value, forKey: "firstName")
        }
        
        if let value = user.lastName {
            parameters.updateValue(value, forKey: "lastName")
        }
        
        self.apiRequestManager.verifierRegistration(parameters: parameters) {
            if let token = $0 {
                UserDefaultsVerifier.setTokenWithSocial(with: token, social: self.userSocial)
            }
            completion($1)
        }
    }
    
    private func showPromocodeAlert(user: User,
                                    _ completion: @escaping (_ result: ResponseResult)->Void) {
        var userWithPromo = user
        
        let alert = UIAlertController(title: "If you have promo code, please enter".localized(), message: "Please enter 8 symbols".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: .default) {[weak self] (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text?.count == 0 {
                
                let okAction = UIAlertAction(title: "OK".localized(), style: .default) { (alertAction) in
                    
                    userWithPromo.promocode = textField.text!
                    
                    self?.didRegistration(with: userWithPromo, { (response) in
                        completion(response)
                    })
                }
                
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .default) { (alertAction) in
                    self?.showPromocodeAlert(user: user, completion)
                }
                
                let alert = UIAlertController(title: "Promo is empty. Do you want to continue?".localized(), message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            } else if textField.text?.count != 8 {
                
                let action = UIAlertAction(title: "OK".localized(), style: .default) { (alertAction) in
                    self?.showPromocodeAlert(user: user, completion)
                }
                
                let alert = UIAlertController(
                    title: "Promo isn't correct".localized(),
                    message: "",
                    preferredStyle: .alert
                )
                alert.addAction(action)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
               
                if let vc = UIApplication.shared.keyWindow?.rootViewController as? VerifierAppDefaultViewController {
                    vc.showAlert(title: "Promo isn't correct".localized(), message: "", action: action)
                }
            } else {
                userWithPromo.promocode = textField.text!
                
                self?.didRegistration(with: userWithPromo, { (response) in
                    completion(response)
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (alertAction) in
            completion(.none)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your promo code".localized()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func didLoginFB(_ completion: @escaping (_ result: ResponseResult)->Void) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                completion(ResponseResult.failed(error.localizedDescription))
            case .cancelled:
                completion(ResponseResult.none)
            case .success(_, _, _):
                
                guard AccessToken.current != nil else { return }
                
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday, age_range"]).start { (_, result) in
                    
                    switch result {
                    case .success(response: let response):
                        
                        let firstName = response.dictionaryValue?["first_name"] as? String ?? "-"
                        let lastName = response.dictionaryValue?["last_name"] as? String ?? "-"
                        let id = response.dictionaryValue?["id"] as? String ?? ""
                        
                        var user = User()
                        
                        user.firstName = firstName
                        user.lastName = lastName
                        user.email = "\(id)@verifier.com"
                        user.password = "123"
                        self.userSocial = "FB"
                        
                        self.showPromocodeAlert(user: user, completion)
                        
                    case .failed(let error):
                        print(error)
                        completion(ResponseResult.failed(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    
}
