//
//  DocumentsView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import TTSegmentedControl

class DocumentsView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!

    
    
    
    func localizationView() {
        screenTitle.text = "Profile.Documents.ScreenTitle".localized()
        
    }
    

}

