//
//  VerificationUserView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 14/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class VerifUserStepOneView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!

    
    
    func localizationView() {
        
        screenTitle.text = "Verification.ScreenTitle".localized()
        
    }
}
