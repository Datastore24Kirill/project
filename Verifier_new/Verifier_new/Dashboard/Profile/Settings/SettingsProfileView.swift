//
//  SettingsProfileView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit


class SettingsProfileView: UIView {

    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    
    
    
    func localizationView() {
        screenTitle.text = "Profile.Settings.ScreenTitle".localized()
        exitButton.setTitle("Exit".localized(), for: .normal)
        
    }
}
