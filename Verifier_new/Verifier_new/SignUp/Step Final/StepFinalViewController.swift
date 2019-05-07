//
//  StepFinalViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 10/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class StepFinalViewController: VerifierAppDefaultViewController, StepFinalViewControllerDelegate {
    
    //MARK: - PROPERTIES
    var model = StepFinalModel()
    var params = [String:String]()
    
    
    @IBOutlet var stepFinalView: StepFinalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stepFinalView.localizationView()
    }
    
    @IBAction func checkEmailButtonAction(_ sender: Any) {
        showSpinner()
        model.didCheckVerifierEmail(with: params)
    }
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func didShowResetPasswordViewController(){
        let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
        let indentifier = ViewControllers.fogotPasswordVC.rawValue
        
        if let fogotPasswordVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? FogotPasswordViewController {
            fogotPasswordVC.isResetPassword = true
            self.navigationController?.pushViewController(fogotPasswordVC, animated: true)
            
        }
    }
}
