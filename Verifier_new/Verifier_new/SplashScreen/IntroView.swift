//
//  IntroView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class IntroView: UIView {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var sloganLabel: UILabel!
    
    
    func localizationView() {
        enterButton.setTitle("Enter".localized(), for: .normal)
        enterButton.layer.cornerRadius = 12
        registrationButton.setTitle("Registration".localized(), for: .normal)
        registrationButton.layer.cornerRadius = 12
    }
}
