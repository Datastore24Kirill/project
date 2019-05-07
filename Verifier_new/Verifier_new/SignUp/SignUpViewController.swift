//
//  SignUpViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyVK

class SignUpViewController: VerifierAppDefaultViewController, SwiftyVKDelegate, SignUpViewControllerDelegate {
    
    
    //MARK: - PROPERTIES
    var nickName : String?
    var vkEmail : String?
    let appId = "6767908"
    let scopes: Scopes = [.offline,.photos,.email]
    var model = SignUpModel()
    
    //MARK: - PROPETIES FOR SEND
    var email:String?
    var fbId:String?
    var vkId:String?
    var nickname:String?
    
    
    
    @IBOutlet var signUpView: SignUpView!
    
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signUpView.localizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VK.setUp(appId: appId, delegate: self)
        model.delegate = self
        
        
    }
    
    //MARK: - ACTION
    
    func didShowSignUpStepTwo() {
        self.view.endEditing(true)
        let params = ["nickname" : signUpView.nicknameTextField.text ?? "", "email" : signUpView.emailTextField.text ?? "", "password" : signUpView.passwordTextField.text ?? ""]
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.signUpStepTwoVC.rawValue
        
        if let signUpStepTwoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignUpStepTwoViewController {
            signUpStepTwoVC.paramsStepOne = params
            self.navigationController?.pushViewController(signUpStepTwoVC, animated: true)
            
        }
    }
    
    @IBAction func enterButtonAction(_ sender: Any) {
        guard let nickname = signUpView.nicknameTextField.text, nickname != "",
            let email = signUpView.emailTextField.text, email != "",
            let password = signUpView.passwordTextField.text, password != "",
            let repeatPassword = signUpView.repeatPasswordTextField.text, repeatPassword != "" else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        if !email.isValidEmail(){
            showAlert(title: "Error".localized(), message: "Error.Email".localized())
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
        
        
        
        didShowSignUpStepTwo()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func facebookActionButton(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! grantedPermissions \(grantedPermissions) declinedPermissions \(declinedPermissions) accessToken \(accessToken)")
                self .fetchUserProfile()
            }
        }
    }
    
    @IBAction func vkontakteActionButton(_ sender: Any) {
        VK.sessions.default.logIn(
            onSuccess: { info in
                print("SwiftyVK: success authorize with", info)
                
        },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
        }
        )
    }
    
    
    
    //
    
    //Facebook
    func fetchUserProfile()
    {
        
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, first_name, last_name, gender"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        
        
        graphRequest.start { (connection, result) in
            
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
                
                
                if let responseDictionary = response.dictionaryValue {
                    if let email = responseDictionary["email"] as? String,
                        let name = responseDictionary["name"] as? String,
                        let id = responseDictionary["id"] as? String {
                        print("email \(email) id \(id)")
                        self.showSpinner()
                        print("email \(email) id \(id)")
                        self.email = email
                        self.nickname = name
                        self.fbId = id
                        self.model.didLoginFB(email: email, fbId: id, nickname: name)
                    }
                }
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
            
        }
        
    }
    //
    
    //SwiftyVKMethod
    
    func usersGet() {
        
        VK.API.Users.get(.empty)
            .configure(with: Config.init(httpMethod: .POST))
            .onSuccess {
                
                let response = try JSONSerialization.jsonObject(with: $0)
                if let array = response as? Array<Any> {
                    
                    
                    for dict in array {
                        if let tempDict = dict as? Dictionary<String, Any> {
                            var name = String()
                            var vkId = String()
                            var email = String()
                            
                            if let fName = tempDict["first_name"] as? String,
                                let lName = tempDict["last_name"] as? String,
                                let _vkId = tempDict["id"] as? Int,
                                let _vkEmail = self.vkEmail{
                                name = fName + " " + lName
                                vkId = String(_vkId)
                                email = _vkEmail
                                self.email = email
                                self.nickname = name
                                self.vkId = vkId
                             
                                self.model.didLoginVK(email: email, vkId: vkId, nickname: name)
                            }
                        }
                        
                    }
                }
                print("SwiftyVK: users.get successed with \n \(response)")
                
                
            }
            .onError { print("SwiftyVK: friends.get fail \n \($0)") }
            .send()
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        self.present(viewController, animated: true)
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        // Called when user grants access and SwiftyVK gets new session token
        // Can be used to run SwiftyVK requests and save session data
        print("token created in session \(sessionId) with info \(info)")
        vkEmail = info["email"]
        self.usersGet()
        
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        // Called when existing session token has expired and successfully refreshed
        // You don't need to do anything special here
        print("token updated in session \(sessionId) with info \(info)")
        vkEmail = info["email"]
        self.usersGet()
    }
    
    func vkTokenRemoved(for sessionId: String) {
        // Called when user was logged out
        // Use this method to cancel all SwiftyVK requests and remove session data
        print("token removed in session \(sessionId)")
    }
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func didShowEmailVerificationPopUp (confirmationEmail: String) {
        
        super.showEmailVerificationPopUp(confirmationEmail: confirmationEmail) {
            self.model.didResendVerifierEmail(with: confirmationEmail)
        }
        
    }
    
    func didShowEmailVerificationAlredySendPopUp (confirmationEmail: String) {
        
        super.showEmailVerificationAlredySendPopUp(confirmationEmail:confirmationEmail){
            self.model.didCheckVerifierEmail(with: confirmationEmail)
        }
        
    }
    
    func didShowSocialPassword(){
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.socialPasswordVC.rawValue
        
        if let socialPasswordVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SocialPasswordViewController {
            socialPasswordVC.nickname = self.nickname
            socialPasswordVC.vkId = self.vkId
            socialPasswordVC.fbId = self.fbId
            socialPasswordVC.email = self.email
            self.navigationController?.pushViewController(socialPasswordVC, animated: true)
            
        }
    }
    
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func showSpinnerView() {
        DispatchQueue.main.async {
            super.showSpinner()
        }
    }
}

//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
}

