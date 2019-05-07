//
//  HelpView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var supportMailLabel: UILabel!
    @IBOutlet weak var rateAppLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    
    func localizationView() {
        faqLabel.text = "FAQ".localized()
        supportMailLabel.text = "SupportMail".localized()
        rateAppLabel.text = "RateApp".localized()
        chatLabel.text = "OnlineSupport".localized()
    }
    

    
    
    
    
}
