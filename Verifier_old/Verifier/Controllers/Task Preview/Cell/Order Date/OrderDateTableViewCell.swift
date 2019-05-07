//
//  OrderDateTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class OrderDateTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDateView: ShadowView!

    @IBOutlet weak var orderDateHintLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!

    @IBOutlet weak var orderTimeHintLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!

    var newOrder = NewOrder()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setDesignChanges()
        localizeUIElement()
    }

    func setDesignChanges() {
        orderDateView.layer.cornerRadius = 16.0
        orderDateView.layer.shadowOffset.width = 0
        orderDateView.layer.shadowOffset.height = 10
        orderDateView.layer.shadowColor = UIColor.verifierGreyShadowColor().cgColor
    }

    func localizeUIElement() {
        orderDateHintLabel.text = "Date".localized()
        orderTimeHintLabel.text = "Time".localized()
    }

    func setData() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM.dd.yyyy HH:mm"

        let dateFrom = dateFormatterGet.string(from: newOrder.dateFrom)
        let dateTo = dateFormatterGet.string(from: newOrder.dateTo)

        let dateFromArray = dateFrom.components(separatedBy: " ")
        let dateToArray = dateTo.components(separatedBy: " ")

        orderDateLabel.text = dateFromArray[0] + " - " + dateToArray[0]
        orderTimeLabel.text = dateFromArray[1] + " - " + dateToArray[1]
    }
}
