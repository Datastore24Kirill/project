//
//  DashboardTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var shapeImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var shapeImageView: UIImageView!
    
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var activeViewBackgroundImageView: UIImageView!

    @IBOutlet weak var activeLabel: UILabel!
    
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vrfLabel: UILabel!
    @IBOutlet weak var myContentView: UIView!

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idHintLabel: UILabel!

    @IBOutlet weak var titleRightActiveConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleShowActiveButtonConstraint: NSLayoutConstraint!

    let gradient = CAGradientLayer()
    var taskStatus = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vrfLabel.text = "Currency".localized()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activeView.cornerRadius = 4.0
    }
    
    func updateContentData(with task: Task) {
        updateDesign(with: task.status)
        updateData(with: task)
        self.setNeedsDisplay()
    }
    
    private func updateDesign(with status: Int) {
        self.myContentView.cornerRadius = 8.0
        
        taskStatus = status

        setupProgressLabel(status: status)

        if status == 2 {

            titleRightActiveConstraint.priority = UILayoutPriority(rawValue: 999)
            titleShowActiveButtonConstraint.priority = UILayoutPriority(rawValue: 333)
            self.idLabel.textColor = UIColor.white
            self.idHintLabel.textColor = UIColor.white
            self.titleLabel.textColor = UIColor.white
            self.locationLabel.textColor = UIColor.white
            self.distanceLabel.textColor = UIColor.white
            self.vrfLabel.textColor = UIColor.white
            
            self.myContentView.isHidden = false
            self.backgroundImageView.isHidden = false
            self.shapeImageView.image = #imageLiteral(resourceName: "Combined Shape 2")
            self.markerImageView.image = #imageLiteral(resourceName: "white_marker")

        } else if status == 3 {
            
            titleRightActiveConstraint.priority = UILayoutPriority(rawValue: 333)
            titleShowActiveButtonConstraint.priority = UILayoutPriority(rawValue: 999)
            
            self.idLabel.textColor = UIColor.black
            self.idHintLabel.textColor = UIColor.black
            self.titleLabel.textColor = UIColor.black
            self.locationLabel.textColor = UIColor.black
            self.distanceLabel.textColor = UIColor.black
            self.vrfLabel.textColor = UIColor.black
            
            self.myContentView.isHidden = false
            self.backgroundImageView.isHidden = true
            self.shapeImageView.image = #imageLiteral(resourceName: "Comb2")
            self.markerImageView.image = #imageLiteral(resourceName: "black_marker")

        } else {
            
            titleRightActiveConstraint.priority = UILayoutPriority(rawValue: 333)
            titleShowActiveButtonConstraint.priority = UILayoutPriority(rawValue: 999)
            
            self.idLabel.textColor = UIColor.black
            self.idHintLabel.textColor = UIColor.black
            self.titleLabel.textColor = UIColor.black
            self.locationLabel.textColor = UIColor.black
            self.distanceLabel.textColor = UIColor.black
            self.vrfLabel.textColor = UIColor.black
            
            self.myContentView.isHidden = false
            self.backgroundImageView.isHidden = true
            self.shapeImageView.image = #imageLiteral(resourceName: "Comb2")
            self.markerImageView.image = #imageLiteral(resourceName: "black_marker")

        }
        
        self.layoutIfNeeded()
    }

    private func setupProgressLabel(status: Int) {

        gradient.frame = self.activeView.bounds

        switch status {
        case 1: //CREATE
            self.activeLabel.text = "CREATE".localized()
            gradient.colors = [UIColor(red: 214/255.0, green: 147/255.0, blue: 49/255.0, alpha: 1.0) , UIColor(red: 243/255.0, green: 189.0/255.0, blue: 43/255.0, alpha: 1.0) ]
            //self.activeView.backgroundColor = UIColor(red: 214/255.0, green: 147/255.0, blue: 49/255.0, alpha: 1.0)
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_orange.png")
        case 2: //ACCEPTED
            self.activeLabel.text = "ACTIVE".localized()
            gradient.colors = [UIColor(red: 68/255.0, green: 233/255.0, blue: 122/255.0, alpha: 1.0) , UIColor(red: 55/255.0, green: 249.0/255.0, blue: 214/255.0, alpha: 1.0) ]
            //self.activeView.backgroundColor = UIColor(red: 68/255.0, green: 233/255.0, blue: 122/255.0, alpha: 1.0)
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_green.png")
        case 3: //VERIFIED
            self.activeLabel.text = "DONE".localized()
            gradient.colors = [UIColor(red: 189/255.0, green: 192/255.0, blue: 207/255.0, alpha: 1.0) , UIColor(red: 189/255.0, green: 192.0/255.0, blue: 207/255.0, alpha: 1.0) ]
            //self.activeView.backgroundColor = UIColor(red: 189/255.0, green: 192/255.0, blue: 207/255.0, alpha: 1.0)
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_grey.png")
        case 4: //APPROVE
            self.activeLabel.text = "APPROVE".localized()
            gradient.colors = [UIColor(red: 68/255.0, green: 233/255.0, blue: 122/255.0, alpha: 1.0) , UIColor(red: 55/255.0, green: 249.0/255.0, blue: 214/255.0, alpha: 1.0) ]
            //self.activeView.backgroundColor = UIColor(red: 68/255.0, green: 233/255.0, blue: 122/255.0, alpha: 1.0)
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_green.png")
        case 5: //CREATE
            self.activeLabel.text = "RETURNED".localized()
            gradient.colors = [UIColor(red: 214/255.0, green: 147/255.0, blue: 49/255.0, alpha: 1.0) , UIColor(red: 243/255.0, green: 189.0/255.0, blue: 43/255.0, alpha: 1.0) ]
            //self.activeView.backgroundColor = UIColor(red: 214/255.0, green: 147/255.0, blue: 49/255.0, alpha: 1.0)
            activeViewBackgroundImageView.image = #imageLiteral(resourceName: "vrf_orange.png")
        default:
            break
        }

        //self.activeView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func updateData(with task: Task) {
        
        self.titleLabel.text = task.title
        self.locationLabel.text = task.city
        self.distanceLabel.text = "\(task.tokens)"

        self.idLabel.text = "\(task.id)"
    }
    
}
