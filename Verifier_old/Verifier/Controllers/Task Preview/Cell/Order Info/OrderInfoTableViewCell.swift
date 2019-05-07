//
//  OrderInfoTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class OrderInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNameHintLabel: UILabel!
    @IBOutlet weak var orderNameLabe: UILabel!

    @IBOutlet weak var orderAddressHintLabel: UILabel!
    @IBOutlet weak var orderAddressCityLabel: UILabel!
    @IBOutlet weak var orderAddressStreetLabel: UILabel!

//    @IBOutlet weak var orderOwnerHintLabel: UILabel!
//    @IBOutlet weak var orderOwnerLabel: UILabel!

    @IBOutlet weak var routeButton: UIButton!

    var newOrder = NewOrder()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setDesignChanges()
        localizeUIElement()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        routeButton.setBlackGradient(view: routeButton)
    }

    func setDesignChanges() {
        routeButton.layer.cornerRadius = 8.0
        routeButton.setBlackGradient(view: routeButton)

        routeButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
        routeButton.sizeToFit()
    }

    func localizeUIElement() {
        orderNameHintLabel.text = "Name of the Order".localized()
        orderAddressHintLabel.text = "Address".localized()
       // orderOwnerHintLabel.text = "Name".localized()

        routeButton.setTitle("Map a route".localized(), for: .normal)
    }

    func setData() {
        if newOrder.ordetType == .new {
            routeButton.isHidden = false
        } else {
            routeButton.isHidden = true
        }

        orderNameLabe.text = newOrder.orderName
      /*  if newOrder.isPhisical {
            orderOwnerLabel.text = newOrder.orderFirstName + " " + newOrder.orderMiddleName + " " + newOrder.orderLastName
        } else {
            orderOwnerLabel.text = ""
        }
      */

        setOrderAddress()
    }

    func setOrderAddress() {

        if newOrder.address == "" {
            return
        }

        let addressArray = newOrder.address.components(separatedBy: ", ")

        orderAddressCityLabel.text = addressArray.count >= 2 ?
            addressArray[0] + ", " + addressArray[1] : newOrder.address

        var streetAddress = ""
        
        if addressArray.count > 2 {
            for index in 2..<addressArray.count {
                streetAddress += addressArray[index]
                streetAddress += ", "
            }
            
            streetAddress = String(streetAddress.dropLast(2))
        }
        
        orderAddressStreetLabel.text = streetAddress
    }

    @IBAction func didPressRouteButton(_ sender: UIButton) {
        InternalHelper.sharedInstance.googleMapsBuildARouteFromPoint(lat: Float(newOrder.lat), lng: Float(newOrder.lng), name: newOrder.orderName)
    }
}
