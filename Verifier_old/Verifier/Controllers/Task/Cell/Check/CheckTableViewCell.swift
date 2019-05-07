//
//  CheckTableViewCell.swift
//  Verifier
//
//  Created by Кирилл on 12/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {
    
    

    var parentVC: BaseDetailTaskViewController? = nil
    
    var cheked = false
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBAction func checkButtonAction(_ sender: Any) {
        
        if cheked {
            checkImageView.image = UIImage(named: "CheckOn")
        } else {
            checkImageView.image = UIImage(named: "Check")
        }
        
    }
}
