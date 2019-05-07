//
//  NoVerifierUserView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 11/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class NoVerifierUserView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTwoLabel: UILabel!
    
    
    func localizationView() {
        screenTitle.text = "NoVerifierUser".localized()
    }
    
    
    
    
    
}

