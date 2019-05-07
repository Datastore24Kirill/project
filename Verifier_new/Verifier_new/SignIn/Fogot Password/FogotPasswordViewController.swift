//
//  FogotPasswordViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

class FogotPasswordViewController: VerifierAppDefaultViewController, FogotPasswordControllerDelegate {

    
    //MARK: - PROPERTIES
    var model = FogotPasswordModel()
    var isResetPassword = false
    var oldPassword = String()
    
    @IBOutlet var fogotPasswordView: FogotPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
        fogotPasswordView.localizationView(isResetPassword: isResetPassword)
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - ACTION
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordButtonAction(_ sender: Any) {
        
        if isResetPassword {
            guard let password = fogotPasswordView.passwordTextField.text, password != "",
                let repeatPassword = fogotPasswordView.repeatPasswordTextField.text, repeatPassword != "" else {
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
            self.model.didResetPassword(oldPassword: oldPassword, newPassword: password)
        } else {
            guard let email = fogotPasswordView.emailTextField.text, email != "" else {
                showAlertError(with: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
            }
            if !email.isValidEmail(){
                showAlert(title: "Error".localized(), message: "Error.Email".localized())
                return
            }
            showSpinner()
            self.model.didFogotPassword(email: email)
        }
        
        
    }
    
    
    
    //MARK: - DELEGATE
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func didShowFogotPasswordPopUp() {
        super.showResetPasswordPopUp() {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didShowChangePasswordPopUp() {
        super.showChangePasswordPopUp() {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getiIsResetPassword() -> Bool {
        return isResetPassword
    }
    
}
