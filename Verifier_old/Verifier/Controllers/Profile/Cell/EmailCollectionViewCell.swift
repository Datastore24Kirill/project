//
//  EmailCollectionViewCell.swift
//  Verifier
//
//  Created by Mac on 16.02.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class EmailCollectionViewCell: DefaultProfileCollectionViewCell {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFied: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var repeatPasswordContainerView: UIView!
    
    var isPasswordValid = false
    var isRepeatPasswordValid = false
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//    }
    
    override func reload() {
        setLocalization()
        setValues()
    }
    
    func setLocalization() {
        emailTextField.placeholder = "Email".localized()
        passwordTextFied.placeholder = "Password".localized()
        repeatPasswordTextField.placeholder = "Repeat password".localized()
    }
    
    func setValues() {
        
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        if let value = user.email {
            emailTextField.text = value
        }
        
        if let social = user.social, social == "FB" || social == "TW" {
            emailTextField.isUserInteractionEnabled = false
            passwordContainerView.isHidden = true
            repeatPasswordContainerView.isHidden = true
        } else {
            
            if let value = User.sharedInstanse.password {
                passwordTextFied.text = value
            } else {
                passwordTextFied.text = nil
            }
            
            if let value = User.sharedInstanse.repeatPassword {
                repeatPasswordTextField.text = value
            } else {
                repeatPasswordTextField.text = nil
            }
            
        }
    }
    
    @IBAction func profileTextFieldsAction(_ sender: UITextField) {
        
        switch sender {
        case emailTextField:
            User.sharedInstanse.email = self.emailTextField.text!
        case passwordTextFied:
            User.sharedInstanse.password = self.passwordTextFied.text!
        case repeatPasswordTextField:
            User.sharedInstanse.repeatPassword = self.repeatPasswordTextField.text!
        default: break
        }
        
    }

}
