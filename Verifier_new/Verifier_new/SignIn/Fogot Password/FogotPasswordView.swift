//
//  FogotPasswordView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit




class FogotPasswordView: UIView {
    
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var emailVerificationTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
   
    @IBOutlet weak var fogotPasswordButton: UIButton!
    
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
     func localizationView(isResetPassword: Bool) {
        screenTitle.text = "FogotPassword.Title".localized()
        
        if isResetPassword {
            resetPasswordView.alpha = 1
            fogotPasswordButton.setTitle("FogotPassword.ResetPassword.Button".localized(), for: .normal)
            passwordTextField.placeholder = "Password".localized()
            repeatPasswordTextField.placeholder = "RepeatPassword".localized()
        }else{
            resetPasswordView.alpha = 0
            emailTextField.placeholder = "Email".localized()
            fogotPasswordButton.setTitle("FogotPassword.Button".localized(), for: .normal)
        }
        
        
    }
    

}
