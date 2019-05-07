//
//  OrderTextTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class OrderTextTableViewCell: PreviewBaseTableViewCell {

    @IBOutlet weak var enterYourDescriptionTextView: UITextView!
    @IBOutlet weak var bottomInfoLabel: UILabel!

    var isEditable = false
    var field = Field()
    var delegate: OrderFieldProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        localizeUIElement()
    }

    func localizeUIElement() {
        
        bottomInfoLabel.text = "Fill out the fields of order to be verified".localized()
    }

    override func updateContentData() {
        nameLabel.text = field.label
        descriptionLabel.text = field.name
        if field.data.count > 0 {
            enterYourDescriptionTextView.text = field.data
        } else {
            enterYourDescriptionTextView.text = ""
        }

        enterYourDescriptionTextView.isEditable = isEditable
    }
}

extension OrderTextTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        field.data.removeAll()
        field.data.append(textView.text)
        delegate?.addNewDescription(field: field)
    }
}
