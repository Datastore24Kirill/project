//
//  VerificationView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class VerificationView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var descrioptionTextView: UITextView!
    
    
    func localizationView() {
    
        screenTitle.text = "Verification.ScreenTitle".localized()
        startChatButton.setTitle("Verification.StartChatButton".localized(), for: .normal)
    
    }
}

