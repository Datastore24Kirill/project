//
//  OrderFieldsTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class OrderFieldsTableViewCell: UITableViewCell {

    @IBOutlet weak var orderFieldsHintLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func localizeUIElement() {
        orderFieldsHintLabel.text = "Order fields".localized()
    }
}
