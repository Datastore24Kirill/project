//
//  DocumentView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit


class DocumentView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    
    
    
    func localizationView() {
        screenTitle.text = "Profile.Settings.ScreenTitle".localized()
        
    }
}

