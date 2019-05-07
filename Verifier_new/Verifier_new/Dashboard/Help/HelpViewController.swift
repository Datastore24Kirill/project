//
//  HelpViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class HelpViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var helpView: HelpView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locolizeTabBar()
        
        helpView.localizationView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - ACTIONS
    @IBAction func faqButtonAction(_ sender: Any) {
        print("FAQ")
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.faqVC.rawValue
        
        if let faqVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? FAQViewController {
            faqVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(faqVC, animated: true)
            
        }
    }
    
    @IBAction func chatButtonAction(_ sender: Any) {
        let storyboard = InternalHelper.StoryboardType.jivoSite.getStoryboard()
        let indentifier = ViewControllers.chatVC.rawValue
        
        if let chatVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? ChatViewController {
            
                chatVC.isShowBackButton = true
                self.navigationController?.pushViewController(chatVC, animated: true)
            
            
            
        }
    }
    
    
    @IBAction func supportMailButtonAction(_ sender: Any) {
        print("SupportMail")
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.feedBackVC.rawValue
        
        if let feedBackVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? FeedBackViewController {
            feedBackVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(feedBackVC, animated: true)
            
        }
    }
    
    @IBAction func rateAppButtonAction(_ sender: Any) {
        print("RateApp")
        super.showRateAppDialog()
    }
}
