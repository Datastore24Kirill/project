//
//  SignUpView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    
    func localizationView() {
        screenTitle.text = "Registration.StepOne".localized()
        nicknameTextField.placeholder = "SignUp.NickName".localized()
        emailTextField.placeholder = "Email".localized()
        passwordTextField.placeholder = "Password".localized()
        repeatPasswordTextField.placeholder = "RepeatPassword".localized()
        nextButton.setTitle("Next".localized(), for: .normal)
    }
}
