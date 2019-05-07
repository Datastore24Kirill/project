//
//  AllTaskView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class AllTaskView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    
    func localizationView() {
    
        screenTitle.text = "AllTask.ScreenTitle".localized()
    
    }
    
    
    
}
