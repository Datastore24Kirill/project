//
//  SocialPasswordViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class SocialPasswordViewController: VerifierAppDefaultViewController, LoginMethodDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var socialPasswordView: SocialPasswordView!
    
    //MARK: - PROPERTIES
    var model = LoginMethod()
    var email:String?
    var fbId:String?
    var vkId:String?
    var nickname:String?
    var allParamsToSend = [String:String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PARAMS \(String(describing: email)) \(String(describing: fbId)) \(String(describing: vkId)) \(String(describing: nickname))")
        
        model.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socialPasswordView.localizationView()
        if let _email = email {
            socialPasswordView.emailTextField.text = _email
            socialPasswordView.emailTextField.alpha = 0
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let nicknameTemp = nickname, nicknameTemp != "",
            let emailTemp = socialPasswordView.emailTextField.text, emailTemp != "",
            let passwordTemp = socialPasswordView.passwordTextField.text, passwordTemp != "",
            let repeatPasswordTemp = socialPasswordView.repeatTextField.text, repeatPasswordTemp != "" else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        if !emailTemp.isValidEmail(){
            showAlert(title: "Error".localized(), message: "Error.Email".localized())
            return
        }
        
        if passwordTemp.count < 6 || repeatPasswordTemp.count < 6 {
            showAlert(title: "Error".localized(), message: "Error.CounElementPassword".localized())
            return
        }
        
        if repeatPasswordTemp != passwordTemp {
            showAlert(title: "Error".localized(), message: "Error.RepeatPassword".localized())
            return
        }
        allParamsToSend = ["email":emailTemp,"password":passwordTemp]
     
        if let vkIdTemp = vkId{
            
            model.didLoginVK(email: emailTemp, vkId: vkIdTemp, nickname: nicknameTemp, password: passwordTemp)
        } else if let fbIdTemp = fbId{
            model.didLoginFB(email: emailTemp, fbId: fbIdTemp, nickname: nicknameTemp, password: passwordTemp)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func didShowStepFinal() {
        self.view.endEditing(true)
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.stepFinalVC.rawValue
        
        if let stepFinalVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? StepFinalViewController {
            stepFinalVC.params = allParamsToSend
            self.navigationController?.pushViewController(stepFinalVC, animated: true)
            
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
