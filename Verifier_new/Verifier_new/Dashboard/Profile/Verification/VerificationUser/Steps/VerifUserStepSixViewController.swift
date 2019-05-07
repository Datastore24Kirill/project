//
//  VerifUserStepSixViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 15/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//



import Foundation
import PopupDialog
import UDatePicker

class VerifUserStepSixViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var innLabel: UITextField!
    @IBOutlet weak var snilsLabel: UITextField!
    
    
    
    //MARK: - PROPERTIES
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localizationView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func localizationView() {
        screenTitle.text = "Verification.ScreenTitle".localized()
        nextButton.setTitle("Next".localized(), for: .normal)
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let inn = innLabel.text, inn != "",
            let snils = snilsLabel.text, snils != "" else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        Singleton.shared.userVerificationData["inn"] = inn
        Singleton.shared.userVerificationData["snils"] = snils
        
        
        print("USER DATA \(Singleton.shared.userVerificationData)")
        
        let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
        let indentifier = ViewControllers.verificationUserStepSevenVC.rawValue
        
        if let verificationUserStepSevenVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepSevenViewController{
            self.navigationController?.pushViewController(verificationUserStepSevenVC, animated: true)
           
        }
        
        
    }
    
    
    
    
    
    
    
}


