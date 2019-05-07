//
//  InstructionView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 29/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit


class InstructionView: UIView {

    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonHeight: NSLayoutConstraint!
    

    func localizationView() {
        
        nextButtonHeight.constant = 0
        nextButton.isUserInteractionEnabled = false
        
        nextButton.setTitle("Instruction.NextButton".localized(), for: .normal)
        screenTitle.text = "Instruction.ScreenTitle".localized()
        
    }
}
