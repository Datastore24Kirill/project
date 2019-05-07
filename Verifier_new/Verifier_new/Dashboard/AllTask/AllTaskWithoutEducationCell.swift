//
//  AllTaskWithoutEducationCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 13/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class  AllTaskWithoutEducationCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var typeTaskLabel: UILabel!
    @IBOutlet weak var titleTaskLabel: UILabel!
    @IBOutlet weak var distanceTaskLabel: UILabel!
    @IBOutlet weak var termTaskLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderLevel: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        termView.layer.cornerRadius = 5
        titleTaskLabel.sizeToFit()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
