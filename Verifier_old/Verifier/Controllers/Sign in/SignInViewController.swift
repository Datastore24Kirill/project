//
//  SignInViewController.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

//

import UIKit


protocol SignInViewControllerOutput: class {
    func didLogin(emailOrId: String, password: String)
    func presentSignUpVC()
    func didLoginFB()
    func presentFogotPassword()

    func presentQRCodeVC()
}

protocol SignInViewControllerInput: class {
    func showAlertError(with title: String?, message: String?)
    func signInViewHideSpinner()
}

class SignInViewController: VerifierAppDefaultViewController {
    
    
    //MARK: - Outlet
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var emailOrIdTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var fogotLabel: UILabel!
    @IBOutlet private weak var signInViaFBLabel: UILabel!
    @IBOutlet private weak var signInViaTwitterLabel: UILabel!
    @IBOutlet private weak var signInViaQRLabel: UILabel!
    @IBOutlet private weak var registrationLabel: UILabel!
    
    
    //MARK: - Properties

    var presenter: SignInViewControllerOutput!
    
    
    // MARK: - lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SignInAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailOrIdTextField.placeholder = "Your E-Mail or ID".localized()
        passwordTextField.placeholder = "Your Password".localized()
        emailOrIdTextField.delegate = self
        passwordTextField.delegate = self
        if #available(iOS 10, *) {
            emailOrIdTextField.textContentType = UITextContentType.emailAddress
            passwordTextField.textContentType = UITextContentType("")
        }
        backgroundView.backgroundColor = UIColor.verifierLoginBackgroundColor()
        signInButton.setTitle("Login".localized().uppercased(), for: .normal)
        signInButton.layer.cornerRadius = 5
        signInButton.backgroundColor = UIColor.verifierLoginButtonPurpleColor()
        
        fogotLabel.attributedText = getFogotAttributedText()
        signInViaFBLabel.attributedText = getFBAttributedText()
        signInViaTwitterLabel.attributedText = getTwitterAttributedText()
        signInViaQRLabel.attributedText = getQRAttributedText()
        registrationLabel.attributedText = getSignUpAttributedText()
    }
    
    
    //MARK: - private
    
    private func getFogotAttributedText() -> NSAttributedString? {
        let fogotAttributedText = NSMutableAttributedString(
            string: "Fogot Password".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.black,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)
            ]
        )
        fogotAttributedText.append(
            NSAttributedString(
                string: "\n" + "Help with sing in".localized(),
                attributes: [
                    NSAttributedStringKey.foregroundColor : UIColor.verifierLoginButtonPurpleColor(),
                    NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)
                ]
            )
        )
        return fogotAttributedText
    }
    
    private func getFBAttributedText() -> NSAttributedString? {
        let fbAttributedText = NSMutableAttributedString(
            string: "Login via".localized() + " " + "Facebook".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.verifierLinkBlueColor(),
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ]
        )
        return fbAttributedText
    }
    
    private func getTwitterAttributedText() -> NSAttributedString? {
        let twitterAttributedText = NSMutableAttributedString(
            string: "Login via".localized() + " " + "Twitter".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.verifierLightBlueColor(),
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ]
        )
        return twitterAttributedText
    }
        
    private func getQRAttributedText() -> NSAttributedString? {
        let qrAttributedText = NSMutableAttributedString(
            string: "Login via".localized() + " " + "QR-code".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.verifierGrayColor(),
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ]
        )
        return qrAttributedText
    }
    
    private func getSignUpAttributedText() -> NSAttributedString? {
        let signUpAttributedText = NSMutableAttributedString(
            string: "Do not have account".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.verifierLightGrayColor(),
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)
            ]
        )
        signUpAttributedText.append(
            NSAttributedString(
                string: " " + "Sign Up".localized(),
                attributes: [
                    NSAttributedStringKey.foregroundColor : UIColor.verifierLoginButtonPurpleColor(),
                    NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)
                ]
            )
        )
        return signUpAttributedText
    }
    
    
    //MARK: - actions
    
    func login() {
        self.view.endEditing(true)
        self.showSpinner()
        presenter.didLogin(emailOrId: emailOrIdTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        guard let email = emailOrIdTextField.text, email != "",
        let password = passwordTextField.text, password != "" else {
            showAlert(title: "InternetErrorTitle".localized(), message: "Error fill all fields".localized())
            return
        }
        
        login()
    }
   
    @IBAction func fogotPasswordButtonAction(_ sender: Any) {
        presenter.presentFogotPassword()
    }
    
    @IBAction func facebookLoginButtonAction(_ sender: Any) {
        showSpinner()
        presenter.didLoginFB()
    }
    
    @IBAction func twitterLoginButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func qrLoginButtonAction(_ sender: Any) {
        presenter.presentQRCodeVC()
    }
    
    @IBAction func registrationButtonAction(_ sender: Any) {
        presenter.presentSignUpVC()
    }
}


//MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
}


//MARK: - SignInViewControllerInput

extension SignInViewController: SignInViewControllerInput {
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func signInViewHideSpinner() {
        hideSpinner()
    }
}

