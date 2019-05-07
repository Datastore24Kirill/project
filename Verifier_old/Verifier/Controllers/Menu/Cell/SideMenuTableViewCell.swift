//
//  DashboardTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var shapeImageView: UIImageView!
    @IBOutlet weak var activeViewBackgroundImageView: UIImageView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vrfLabel: UILabel!
    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idHintLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateContentData(with task: Task) {
        
        myContentView.layer.masksToBounds = false
        myContentView.layer.shadowColor = UIColor.verifierShadowPinkColor().cgColor
        myContentView.layer.shadowOpacity = 1
        myContentView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        myContentView.layer.shadowRadius = 10

        setupProgressLabel(status: task.status)

        // Round the corners
        idLabel.text = "\(task.id)" 
        titleLabel.text = task.title
        locationLabel.text = task.city
        vrfLabel.text = "\(task.tokens)"
    }

    private func setupProgressLabel(status: Int) {

        switch status {
        case 1: //CREATE
            self.doneLabel.text = "CREATE".localized()
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_orange.png")
        case 2: //ACCEPTED
            self.doneLabel.text = "ACTIVE".localized()
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_green.png")
        case 3: //VERIFIED
            self.doneLabel.text = "DONE".localized()
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_grey.png")
        case 4: //APPROVE
            self.doneLabel.text = "APPROVE".localized()
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_green.png")
        case 5: //RETURNED
            self.doneLabel.text = "RETURNED".localized()
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_green.png")
        default:
            break
        }
    }
}
