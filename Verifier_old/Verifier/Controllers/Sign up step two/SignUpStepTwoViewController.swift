//
//  SignUpStepTwoViewController.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SignUpStepTwoViewControllerOutput: class {
    func didRegistration(with user: User)
    func didResetPassword(with user: User)
    func presentPreviousVC()
}

protocol SignUpStepTwoViewControllerInput: class {
    func showAlertError(with title: String?, message: String?)
    
    func signUpStepTwoViewHideSpinner()
}

class SignUpStepTwoViewController: VerifierAppDefaultViewController {
    
    //MARK: Outlet
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    @IBOutlet private weak var promoCodeTextField: UITextField!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var signUpInfoLabel: UILabel!
    var user: User?
    
    
    //MARK: Properties
    var isResetPassword = false
    var presenter: SignUpStepTwoViewControllerOutput!
    
    
    // MARK: UIViewController Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SignUpStepTwoAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.placeholder = "Password".localized()
        repeatPasswordTextField.placeholder = "RepeatPassword".localized()
        promoCodeTextField.placeholder = "Enter promo code".localized()
        backgroundView.backgroundColor = UIColor.verifierLoginBackgroundColor()
        if isResetPassword {
            registrationButton.setTitle("ResetPassword.Button".localized().uppercased(), for: .normal)
             signUpInfoLabel.text = ""
        } else {
            registrationButton.setTitle("Registration".localized().uppercased(), for: .normal)
             signUpInfoLabel.attributedText = getsignUpInfoAttributedText()
        }
        
        registrationButton.backgroundColor = UIColor.verifierDarkBlueColor()
        
       
        signUpInfoLabel.textAlignment = .center
    }
    
    
    //MARK: private
    
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
    
    private func registration() {
        
            
            guard let user = user else {
                showAlert(title: "InternetErrorTitle".localized(), message: "")
                return
            }
        print("user: \(user)")
            showSpinner()
        if isResetPassword {
            presenter.didResetPassword(with: user)
        } else {
            presenter.didRegistration(with: user)
            
        }
        
    }
    
    private func showPromocodeAlert() {
        let alert = UIAlertController(title: "Promo is empty. Do you want to continue?".localized(), message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let okAction = UIAlertAction(title: "OK".localized(), style: .default) { [weak self] (alertAction) in
            
            self?.user?.promocode = self?.promoCodeTextField.text
            self?.registration()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (alertAction) in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
    }
    
    private func validationPassword() -> Bool {
        guard let password = passwordTextField.text, password != "" else {
                showAlert(title: "InternetErrorTitle".localized(), message: "PasswordErrorMessage".localized())
            
                return false
        }
        
        guard password.count > 5 else {
            showAlert(title: "InternetErrorTitle".localized(), message: "Пароль должен быть не менее 6 символов")
            
            return false
        }
        
        
        guard let repeatPassword = repeatPasswordTextField.text, repeatPassword != "" else {
            showAlert(title: "InternetErrorTitle".localized(), message: "ConfirmPasswordErrorMessage".localized())
            return false
        }
        
        guard repeatPassword == password else {
            showAlert(title: "InternetErrorTitle".localized(), message: "ConfirmAndPasswordErrorMessage".localized())
            return false
        }
        
        if isResetPassword {
            self.user = User()

        }
        
        
        self.user?.password = password
        self.user?.repeatPassword = repeatPassword
        
        return true
    }
    
    private func validationPromoCode() -> Bool {
        guard let promo = promoCodeTextField.text, promo != "" else {
            showPromocodeAlert()
            return false
        }
        
        guard promo.count == 8 else {
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            self.showAlert(title: "Promo isn't correct".localized(), message: "", action: okAction)
            return false
        }
        
        return true
    }
    
    
    //MARK: Actions
    
    @IBAction func backButton(_ sender: Any) {
        presenter.presentPreviousVC()
    }
    
    @IBAction func registrationButtonAction(_ sender: Any) {
        if validationPassword() {
            registration()
        }
    }
}


//MARK: ViewControllerInput

extension SignUpStepTwoViewController: SignUpStepTwoViewControllerInput {
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func signUpStepTwoViewHideSpinner() {
        hideSpinner()
    }
}
