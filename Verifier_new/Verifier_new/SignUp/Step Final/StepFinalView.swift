//
//  StepFinalView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 10/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class StepFinalView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var checkEmailButton: UIButton!
    @IBOutlet weak var emailVerificationLabel: UILabel!
    
    

    func localizationView() {
        screenTitle.text = "StepFinal".localized()
        checkEmailButton.setTitle("Button.ConfirmEmail".localized(), for: .normal)
        emailVerificationLabel.text = "StepFinal.EmailNeedVerification".localized()
    }
    
    
    
    
}
