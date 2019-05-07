//
//  FilterHeaderTableViewCell.swift
//  Verifier
//
//  Created by Mac on 4/23/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FilterHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    var element: FilterDataHeaderModel! {
        didSet {
            nameLabel.text = element.title
            dotImage.isHidden = element.isHiddenDot
            arrowImage.image = element.opened ? #imageLiteral(resourceName: "@arrow_up_grey_icon") : #imageLiteral(resourceName: "arrow_down_grey_icon")
        }
    }
    
}
