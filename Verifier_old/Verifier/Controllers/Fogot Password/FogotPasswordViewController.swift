//
//  FogotPasswordViewController.swift
//  Verifier
//
//  Created by Кирилл on 16/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit


protocol FogotPasswordViewControllerOutput: class {
    func didSendPassword(emailOrId: String)
    func presentPreviousVC()
}

protocol FogotPasswordViewControllerInput: class {
    func showAlertError(with title: String?, message: String?)
    func signInViewHideSpinner()
    func showResultSendPassword()
}

class FogotPasswordViewController: VerifierAppDefaultViewController {
    
    
    //MARK: - Outlet
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var emailOrIdTextField: UITextField!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //MARK: - Properties
    
    var presenter:  FogotPasswordViewControllerOutput!
    
    
    // MARK: - lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ForgotPasswordAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "FogotPassword.Title".localized()
        resultLabel.alpha = 0
        emailOrIdTextField.placeholder = "Your E-Mail or ID".localized()
        emailOrIdTextField.delegate = self
        if #available(iOS 10, *) {
            emailOrIdTextField.textContentType = UITextContentType.emailAddress
        }
        backgroundView.backgroundColor = UIColor.verifierLoginBackgroundColor()
        resetPasswordButton.setTitle("FogotPassword.Button".localized().uppercased(), for: .normal)
        //resetPasswordButton.layer.cornerRadius = 5
        resetPasswordButton.backgroundColor = UIColor.verifierLoginButtonPurpleColor()
 
        
    }

    
    //MARK: - actions
    
    func login() {
        self.view.endEditing(true)
        self.showSpinner()
        presenter.didSendPassword(emailOrId: emailOrIdTextField.text!)
    }
    
    @IBAction func fogotPasswordButtonAction(_ sender: Any) {
        guard let email = emailOrIdTextField.text, email != "" else {
                showAlert(title: "InternetErrorTitle".localized(), message: "Error fill all fields".localized())
                return
        }
        
        login()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        presenter.presentPreviousVC()
    }
    
    
    
}


//MARK: - UITextFieldDelegate

extension FogotPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
}


//MARK: - FogotPasswordViewControllerInput

extension FogotPasswordViewController: FogotPasswordViewControllerInput {
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func signInViewHideSpinner() {
        hideSpinner()
    }
    
    func showResultSendPassword() {
        let resultAttributedText = NSMutableAttributedString(
            string: "FogotPassword.Message.Success".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.verifierLightGrayColor(),
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 26)
            ]
        )
        hideSpinner()
        resultLabel.alpha = 1
        resultLabel.attributedText = resultAttributedText
        
        emailOrIdTextField.alpha = 0
        resetPasswordButton.alpha = 0
        resetPasswordButton.isUserInteractionEnabled = false
    }
}
