//
//  PreviewBaseTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 09.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class PreviewBaseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameHintLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentDataView: ShadowView!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentDataView.layer.cornerRadius = 16.0
        contentDataView.layer.shadowOffset.width = 0
        contentDataView.layer.shadowOffset.height = 10
        contentDataView.layer.shadowColor = UIColor.verifierGreyShadowColor().cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateContentData() {
        
    }
}
