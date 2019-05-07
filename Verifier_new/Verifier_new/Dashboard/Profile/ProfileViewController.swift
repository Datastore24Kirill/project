//
//  ProfileViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 17/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: VerifierAppDefaultViewController, ProfileViewControllerDelegate, NotificationModelDelegate {
   
    
    
    
    //MARK: - OUTLETS
    @IBOutlet var profileView: ProfileView!
    
    
    //MARK: - PROPERTIES
    let model = ProfileModel()
    let modelNotification = NotificationModel()
    var userInfo: [String: Any]?
    var verificationStatus: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locolizeTabBar()
        
        showSpinner()
        model.delegate = self
        modelNotification.delegate = self
        
        profileView.localizationView()
        modelNotification.getBadges()
        model.getVerifierUserInfo()
    }
    
    
    //MARK: - ACTIONS
    @IBAction func settingsButtonAction(_ sender: Any) {
        
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.settingsProfileVC.rawValue
        
        if let profileSettingsVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SettingsProfileViewController {
            Singleton.shared.userInfo = userInfo
            profileSettingsVC.verificationStatus = verificationStatus
            profileSettingsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileSettingsVC, animated: true)
            
        }
        
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        print("Notification")
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.notificationVC.rawValue
        
        if let notificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? NotificationViewController {
            notificationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notificationVC, animated: true)
            
        }
        
    }
    
    
    @IBAction func verificationButtonAction(_ sender: Any) {
        
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.verificationVC.rawValue
        
        if let verificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerificationViewController {
            verificationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(verificationVC, animated: true)
            
        }
        
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [String: Any]) {
        
        var userInfoResult = [String: Any]()
        
        let changeable = data["changeable"] as! [String : Any]
        let unchangeable = data["unchangeable"] as! [String: Any]
        
        let firstName = (unchangeable["firstName"] as? String) ?? "Не указано"
        let lastName = (unchangeable["lastName"] as? String) ?? "Не указано"
        let nickName = (changeable["nickname"] as? String) ?? "Не указано"
        let balanceString = String((data["balance"] as? Int) ?? 0)
        
        userInfoResult["nickname"] = nickName
        userInfoResult["firstName"] = firstName
        userInfoResult["lastName"] = lastName
        
        
        
        let type = data["type"] as? String
        
        let typeString: String?
        switch type {
        case "VERIFIER":
            typeString = "Profile.Status.Verifier".localized()
        case "PRE_VERIFIER":
            typeString = "Profile.Status.PreVerifier".localized()
        default:
            typeString = "Profile.Status.Unknowed".localized()
            break
        }
        
        verificationStatus = data["verificationStatus"] as? Int
        var verificationStatusString: String?
        var verificationStatusColor: String?
        
        switch verificationStatus {
        case 0:
            verificationStatusString = "Profile.Status.NotIdentified".localized()
            verificationStatusColor = "#ED0648"
            profileView.verificationButton.isUserInteractionEnabled = true
        case 1:
            verificationStatusString = "Profile.Status.OnCheck".localized()
            verificationStatusColor = "#E29205"
            profileView.verificationButton.isUserInteractionEnabled = false
            
        case 2:
            verificationStatusString = "Profile.Status.Verified".localized()
            verificationStatusColor = "#00B497"
            profileView.verificationButton.isUserInteractionEnabled = false
        case 3:
            verificationStatusString = "Profile.Status.RequiresVerification".localized()
            verificationStatusColor = "#ED0648"
            profileView.verificationButton.isUserInteractionEnabled = true
        default:
            break
        }
        
        let photoLink = (changeable["photo"] as? String) ?? ""
        
        userInfoResult["photo"] = photoLink
        userInfoResult["email"] = (unchangeable["email"] as? String) ?? ""
        userInfoResult["phone"] = (changeable["phone"] as? String) ?? ""
        userInfoResult["birthdate"] = (unchangeable["birthDate"] as? Int)
        
        let rating = data["rating"] as? Int
        
        profileView.nickNameLabel.text = nickName
        profileView.moneyLabel.text = "Profile.Balance".localized(param: balanceString)
        profileView.userTypeLabel.text = typeString
        profileView.userRatingView.rating = Double(rating ?? 0)
        profileView.verificationStatus.text = verificationStatusString
        profileView.verificationStatus.textColor = UIColor(verificationStatusColor ?? "#ED0648")
        
       
        profileView.profileAvatarInView.layer.masksToBounds = false
        profileView.profileAvatarInView.clipsToBounds = true

        profileView.profileAvatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        profileView.profileAvatarImageView.sd_imageIndicator = SDWebImageProgressIndicator.default
        profileView.profileAvatarImageView.sd_setImage(with: URL(string: photoLink), placeholderImage: nil)
        
        profileView.profileAvatarInView.contentMode = .scaleAspectFill
        
        userInfo = userInfoResult
        
    }
    
    func updateBadges(data: [String: Any]) {
        if let badge = data["unreadNotificationsCount"] as? Int {
            if badge > 0 {
                profileView.badgesView.text = String(badge)
                profileView.buttonAnimation(isShowBadges: true)
            } else {
                profileView.buttonAnimation(isShowBadges: false)
            }
            
            
        }
    }
    
}
