//
//  ChangePasswordViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit


class ChangePasswordViewController: VerifierAppDefaultViewController, ChangePasswordViewControllerDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var changePasswordView: ChangePasswordView!
    
    //MARK: - PROPERTIES
    let model = ChangePasswordModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changePasswordView.localizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        guard let oldPassword = changePasswordView.oldPasswordTextField.text, oldPassword != "", let password = changePasswordView.passwordTextField.text, password != "",
            let repeatPassword = changePasswordView.repeatPasswordTextField.text, repeatPassword != "" else {
                showAlertError(with: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        if password.count < 6 || repeatPassword.count < 6 {
            showAlert(title: "Error".localized(), message: "Error.CounElementPassword".localized())
            return
        }
        
        if repeatPassword != password {
            showAlert(title: "Error".localized(), message: "Error.RepeatPassword".localized())
            return
        }
        showSpinner()
        model.didResetPassword(oldPassword: oldPassword, newPassword: password)
    }
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func didShowChangePasswordPopUp() {
        super.showChangePasswordPopUp() {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}
