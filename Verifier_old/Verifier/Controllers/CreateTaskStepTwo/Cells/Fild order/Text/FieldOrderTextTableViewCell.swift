//
//  FieldOrderTextTableViewCell.swift
//  Verifier
//
//  Created by Mac on 5/2/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FieldOrderTextTableViewCell: FieldOrderDefaultTableViewCell {
    
    //MARK: - UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleImageView.image = #imageLiteral(resourceName: "@text_field_icon")
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        NewOrder.sharedInstance.fields[currentIndexPath.row].label = titleTextField.text!
    }
}
