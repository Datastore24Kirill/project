//
//  FAQView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class FAQView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    
    func localizationView() {
        screenTitle.text = "FAQ".localized()
    }
}
