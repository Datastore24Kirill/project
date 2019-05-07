//
//  ProfileView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 17/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//


import UIKit
import Cosmos
import BadgeSwift

class ProfileView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var profileAvatarOutView: UIView!
    @IBOutlet weak var profileAvatarInView: UIView!
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var myMoneyLabel: UILabel!
    @IBOutlet weak var educationButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var getMyMoneyLabel: UILabel!
    @IBOutlet weak var visaView: UIView!
    @IBOutlet weak var mastercardView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var verificationStatus: UILabel!
    @IBOutlet weak var badgesView: BadgeSwift!
    @IBOutlet weak var verificationButton: UIButton!
    
    
    
    
    
    
    func localizationView() {
        profileAvatarInView.layer.cornerRadius = profileAvatarImageView.frame.size.width/2
        profileAvatarInView.clipsToBounds = true
        profileAvatarInView.layer.borderColor = UIColor.white.cgColor
        profileAvatarInView.layer.borderWidth = 5
        visaView.layer.cornerRadius = 10
        mastercardView.layer.cornerRadius = 10
        badgesView.alpha = 0
        badgesView.badgeColor = UIColor.clear
        badgesView.textColor = UIColor.clear
        
        myMoneyLabel.text = "Profile.MyMoney".localized()
        getMyMoneyLabel.text = "Profile.GetMyMoney".localized()
        statusLabel.text = "Profile.Status".localized()
        moneyLabel.text = "Profile.Balance".localized(param: "500")
        
        self.bringSubviewToFront(notificationButton)
        
       
        
    }
    
    func buttonAnimation(isShowBadges: Bool){
        let pathNotificationButton = UIBezierPath()
        pathNotificationButton.move(to: CGPoint(x: -76,y: 386))
        pathNotificationButton.addCurve(to: CGPoint(x: 311, y: 424), controlPoint1: CGPoint(x: 126, y: 424), controlPoint2: CGPoint(x: 156, y: 424))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let animNotificationButton = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        animNotificationButton.path = pathNotificationButton.cgPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        animNotificationButton.rotationMode = CAAnimationRotationMode.rotateAuto
        
        animNotificationButton.duration = 0.5
        CATransaction.begin()
        CATransaction.setCompletionBlock{
            
            let animShakeNotificationButton = CABasicAnimation(keyPath: "position")
            animShakeNotificationButton.duration = 0.07
            animShakeNotificationButton.repeatCount = 2
            animShakeNotificationButton.autoreverses = true
            animShakeNotificationButton.fromValue = NSValue(cgPoint: CGPoint(x: self.notificationButton.center.x - 5, y: self.notificationButton.center.y))
            animShakeNotificationButton.toValue = NSValue(cgPoint: CGPoint(x: self.notificationButton.center.x + 5, y: self.notificationButton.center.y))
            self.notificationButton.layer.add(animShakeNotificationButton, forKey: "educationShakeButtonAnimation")
            
        }
        
        // we add the animation to the squares 'layer' property
        notificationButton.layer.add(animNotificationButton, forKey: "NotificationButtonAnimation")
        CATransaction.commit()
        
        let pathEducationButton = UIBezierPath()
        pathEducationButton.move(to: CGPoint(x: -106,y: 386))
        pathEducationButton.addCurve(to: CGPoint(x: 241, y: 424), controlPoint1: CGPoint(x: 126, y: 424), controlPoint2: CGPoint(x: 156, y: 424))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let animEducationButton = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        animEducationButton.path = pathEducationButton.cgPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        animEducationButton.rotationMode = CAAnimationRotationMode.rotateAuto
    
        animEducationButton.duration = 1.0
        CATransaction.begin()
        CATransaction.setCompletionBlock{
           
            let animShakeEducationButton = CABasicAnimation(keyPath: "position")
            animShakeEducationButton.duration = 0.07
            animShakeEducationButton.repeatCount = 2
            animShakeEducationButton.autoreverses = true
            animShakeEducationButton.fromValue = NSValue(cgPoint: CGPoint(x: self.educationButton.center.x - 5, y: self.educationButton.center.y))
            animShakeEducationButton.toValue = NSValue(cgPoint: CGPoint(x: self.educationButton.center.x + 5, y: self.educationButton.center.y))
            self.educationButton.layer.add(animShakeEducationButton, forKey: "educationShakeButtonAnimation")

        }
        
        // we add the animation to the squares 'layer' property
        educationButton.layer.add(animEducationButton, forKey: "educationButtonAnimation")
        CATransaction.commit()
        
        UIView.animate(withDuration: 3.2) {
            if isShowBadges {
                
                self.badgesView.alpha = 1
                self.badgesView.badgeColor = UIColor.red
                self.badgesView.textColor = UIColor.white
            } else {
                self.badgesView.alpha = 0
                self.badgesView.badgeColor = UIColor.clear
                self.badgesView.textColor = UIColor.clear
            }
        }
        
        
      
    }
    
    
}
