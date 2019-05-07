//
//  PreviewTextTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 08.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class PreviewTextTableViewCell: PreviewBaseTableViewCell {

    var field = Field()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        localizeUIElement()
    }

    func localizeUIElement() {
        nameHintLabel.text = "Name of the field".localized()
    }

    override func updateContentData() {
        nameLabel.text = field.label
        descriptionLabel.text = field.name
    }
}
