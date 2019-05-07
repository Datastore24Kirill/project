//
//  LaunchViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 25/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation

class LaunchViewController: VerifierAppDefaultViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let resultsRealm = RealmSwiftAction.listRealm().first
        if resultsRealm?.isFirstLaunch == false {
            didShowIntroViewController(animation: false)
        } else {
            didShowSplashViewController(animation: false)
        }
    }
    
    func didShowIntroViewController (animation: Bool) {
        let storyboard = InternalHelper.StoryboardType.splashScreen.getStoryboard()
        let indentifier = ViewControllers.introvC.rawValue
        
        if let introvC = storyboard.instantiateViewController(withIdentifier: indentifier) as? IntroViewController {
            
            self.navigationController?.pushViewController(introvC, animated: animation)
            
        }
    }
    
    func didShowSplashViewController (animation: Bool) {
        let storyboard = InternalHelper.StoryboardType.splashScreen.getStoryboard()
        let indentifier = ViewControllers.splashScreenVC.rawValue
        
        if let splashScreenVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SplashScreenViewController {
            
            self.navigationController?.pushViewController(splashScreenVC, animated: animation)
            
        }
    }
}
