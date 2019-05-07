//
//  ChangePasswordView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    func localizationView()  {
        screenTitle.text = "ChangePassword.ScreenTitle".localized()
        changePasswordButton.setTitle("ChangePassword".localized(), for: .normal)
        oldPasswordTextField.placeholder = "OldPassword".localized()
        passwordTextField.placeholder = "Password".localized()
        repeatPasswordTextField.placeholder = "RepeatPassword".localized()
    }
}
