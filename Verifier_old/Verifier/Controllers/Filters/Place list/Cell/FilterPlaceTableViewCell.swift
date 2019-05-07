//
//  FiterPlaceViewCell.swift
//  Verifier
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FilterPlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateContent(location: String) {
        self.titleLabel.text = location
    }
    
}
