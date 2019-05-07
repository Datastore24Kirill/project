//
//  VerificationViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

class VerificationViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: VerificationView!
    @IBOutlet weak var agreementSwitch: UISwitch!
    
    //MARK: - PROPERTIES
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verificationView.localizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func startChatButtonAction(_ sender: Any) {
        
        if agreementSwitch.isOn {
            let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
            let indentifier = ViewControllers.verificationUserVC.rawValue
            
            if let verificationUserVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepOneViewController {
                self.navigationController?.pushViewController(verificationUserVC, animated: true)
                
            }
        } else{
            showAlert(title: "Error".localized(), message: "Verification.SwitchError".localized())
        }
        
    }
    
}
