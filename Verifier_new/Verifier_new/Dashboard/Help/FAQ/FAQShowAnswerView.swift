//
//  FAQShowAnswerView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class FAQShowAnswerView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    
    
    
    func localizationView() {
        screenTitle.text = "FAQ".localized()
    }
}
