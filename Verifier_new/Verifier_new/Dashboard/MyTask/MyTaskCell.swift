//
//  MyTaskCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 25/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import UICircularProgressRing

class  MyTaskCell: UITableViewCell {

//MARK: - OUTLETS
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var typeTaskLabel: UILabel!
    @IBOutlet weak var titleTaskLabel: UILabel!
    @IBOutlet weak var addressTaskLabel: UILabel!
    @IBOutlet weak var statusTaskLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderLevel: UIImageView!
    @IBOutlet weak var circularProgreeRing: UICircularProgressRing!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = 5
        circularProgreeRing.font = UIFont.systemFont(ofSize: 11)
        circularProgreeRing.style = .bordered(width: 1, color: UIColor("#4848F7"))
        circularProgreeRing.innerRingWidth = 3
        circularProgreeRing.outerRingColor = UIColor.white
        circularProgreeRing.outerRingWidth = 3
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
