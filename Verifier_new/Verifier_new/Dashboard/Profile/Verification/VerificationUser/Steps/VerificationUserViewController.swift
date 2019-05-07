//
//  VerificationUserViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 14/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import PopupDialog

class VerifUserStepOneViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: VerificationUserView!
    @IBOutlet weak var conainerView: UIView!
    
    //MARK: - PROPERTIES
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verificationView.localizationView()
        
        // Load Storyboard
        let storyboard = UIStoryboard(name: "VerificationUser", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "StepOneViewController") 

        viewController.view.frame = conainerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth]
        conainerView.addSubview(viewController.view)
        showStepOnePopup()
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func showStepOnePopup(animated: Bool = true) {
        
        // Create a custom view controller
        
        
        // Create the dialog
        let popup = PopupDialog(title: "Вопрос", message: "Являетесь ли вы студентом очной формы обучения?", image: nil)
        
        // Create first button
        let buttonOne = DefaultButton(title: "Да", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = CancelButton(title: "Нет", height: 60) {
            self.showAlert(title: "", message: "Приносим свои извинения, на данный момент мы не можем оформить вас официально")
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }

}
