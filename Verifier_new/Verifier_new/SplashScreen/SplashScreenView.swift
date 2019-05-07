//
//  SplashScreenView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class SplashScreenView: UIView {
    
    //MARK: - OUTLETS    
    @IBOutlet weak var nextButton: UIButton!
    
    
    func localizationView() {
        nextButton.setTitle("Skip".localized(), for: .normal)
        nextButton.layer.cornerRadius = 12
    }
    
}
