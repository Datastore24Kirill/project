//
//  NoVerifierUserViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 11/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class NoVerifierUserViewController: VerifierAppDefaultViewController {
    //MARK: - Properties
    
    @IBOutlet var noVerifierUserView: NoVerifierUserView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noVerifierUserView.localizationView()
    }
    
    //MARK: - ACTIONS
    @IBAction func goodButtonAction(_ sender: Any) {
        
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let dashboardNAVVC = storyboard.instantiateViewController(withIdentifier: "DashboardNAVVC") as! UITabBarController
        
        dashboardNAVVC.selectedIndex = 2;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = dashboardNAVVC
        
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let dashboardNAVVC = storyboard.instantiateViewController(withIdentifier: "DashboardNAVVC") as! UITabBarController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = dashboardNAVVC

        
        
        
    }
}
