//
//  FeedBackViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class  FeedBackViewController: VerifierAppDefaultViewController, FeedBackViewControllerDelegate {

    //MARK: - OUTLETS
    @IBOutlet var feedBackView: FeedBackView!
    
    //MARK: - PROPERTIES
    let model = FeedBackModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedBackView.localizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func sendButtonAction(_ sender: Any) {
        
        guard let name = feedBackView.nameTextField.text, name != "",
            let email = feedBackView.emailTextField.text, email != "",
            let message = feedBackView.messageTextView.text, message != "FeedBack.Message".localized() else {
                showAlertError(with: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        if !email.isValidEmail(){
            showAlert(title: "Error".localized(), message: "Error.Email".localized())
            return
        }
        
    
        showSpinner()
        print("Send")
        model.sendFeedBack(name: name, text: message)
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
}
