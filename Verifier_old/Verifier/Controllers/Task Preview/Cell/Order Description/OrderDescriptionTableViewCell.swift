//
//  OrderDescriptionTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class OrderDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDescriptionHintLabel: UILabel!
    @IBOutlet weak var orderDescriptionTextView: UITextView!
    
    
    var newOrder = NewOrder()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        localizeUIElement()
    }

    func localizeUIElement() {
        orderDescriptionHintLabel.text = "Description".localized()
    }

    func setData() {
        print("DESCT \(newOrder.orderComment)")
        orderDescriptionTextView.text = newOrder.orderComment
    }
}
