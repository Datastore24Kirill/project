//
//  SignUpViewController.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SignUpViewControllerOutput: class {
    func presentSignUpStepTwoViewController(user: User)
    func presentQRCodeVC()
    func presentPreviousVC()
}

protocol SignUpViewControllerInput: class {
    func showAlertError(with title: String?, message: String?)
    func signInViewHideSpinner()
}

class SignUpViewController: VerifierAppDefaultViewController {
    
    
    //MARK: Outlet
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var signInViaFBLabel: UILabel!
    @IBOutlet private weak var signInViaTwitterLabel: UILabel!
    @IBOutlet private weak var signInViaQRLabel: UILabel!
    @IBOutlet private weak var signUpInfoLabel: UILabel!
    @IBOutlet weak var checkButtonPolice: UIButton!
    
    //BOOL for Policy
    
    var isCheckAgreement = false
    
    //MARK: Properties
    var presenter: SignUpViewControllerOutput!
    
    
    // MARK: UIViewController Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        SignUpAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.placeholder = "First name".localized()
        lastNameTextField.placeholder = "Last name".localized()
        emailTextField.placeholder = "Email".localized()
        emailTextField.delegate = self
        backgroundView.backgroundColor = UIColor.verifierLoginBackgroundColor()
        continueButton.setTitle("Continue".localized().uppercased(), for: .normal)
        continueButton.backgroundColor = UIColor.verifierDarkBlueColor()
        
//        signInViaFBLabel.attributedText = getFBAttributedText()
//        signInViaTwitterLabel.attributedText = getTwitterAttributedText()
//        signInViaQRLabel.attributedText = getQRAttributedText()
        signUpInfoLabel.attributedText = getsignUpInfoAttributedText()
        signUpInfoLabel.textAlignment = .center
    }
    
    //MARK: private
    
    private func getFBAttributedText() -> NSAttributedString? {
        let fbAttributedText = NSMutableAttributedString(
            string: "through".localized() + " " + "Facebook".localized(),
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
            string: "through".localized() + " " + "Twitter".localized(),
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
            string: "through".localized() + " " + "QR-code".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.verifierGrayColor(),
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ]
        )
        return qrAttributedText
    }
    
    private func getsignUpInfoAttributedText() -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        let signUpInfoAttributedText = NSMutableAttributedString(
            string: "Registration Info".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.white,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.paragraphStyle : paragraphStyle
            ]
        )
        return signUpInfoAttributedText
    }
    
    
    //MARK: Actions
    
    
    @IBAction func continueButtonAction(_ sender: Any) {
        guard let firstName = firstNameTextField.text, firstName != "",
        let secondName = lastNameTextField.text, secondName != "",
        let email = emailTextField.text, email != "" else {
            showAlert(title: "InternetErrorTitle".localized(), message: "Error fill all fields".localized())
            return
        }
        
        if !email.isValidEmail() {
            showAlert(title: "InternetErrorTitle".localized(), message: "EmailErrorMessage".localized())
            return
        }
        
        if !isCheckAgreement {
            showAlert(title: "InternetErrorTitle".localized(), message: "Необходимо подтвердить согласие с Политикой конфиденциальности")
            return
        }
        
        var user = User()
        user.firstName = firstName
        user.lastName = secondName
        user.email = email
        
        presenter.presentSignUpStepTwoViewController(user: user)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        presenter.presentPreviousVC()
    }
    
    @IBAction func qrLoginButtonAction(_ sender: Any) {
        presenter.presentQRCodeVC()
    }
    
    @IBAction func didPressCheckButton(_ sender: Any) {
        
        if !isCheckAgreement {
            self.isCheckAgreement = true
            self.checkButtonPolice.setImage(R.image.checkIconActive(), for: UIControlState.normal)
        } else {
            self.isCheckAgreement = false
            self.checkButtonPolice.setImage(R.image.checkIconNoActive(), for: UIControlState.normal)
        }
        
    }
    
    @IBAction func didPressPoliceAgreement(_ sender: Any) {
    }
    
}


//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
}


//MARK: ViewControllerInput
extension SignUpViewController: SignUpViewControllerInput {
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func signInViewHideSpinner() {
        hideSpinner()
    }
}
