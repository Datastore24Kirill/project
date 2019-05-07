//
//  SignUpStepTwoRouting.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SignUpStepTwoRouting: SignUpStepTwoPresenterOutput {

    weak var viewController: SignUpStepTwoViewController!
    
    func didOpenDashboardVC(email: String) {
        viewController.hideSpinner()
        
        let storyboard = InternalHelper.StoryboardType.emailVerification.getStoryboard()
        let indentifier = ViewControllers.emailVerificationVC.rawValue
        
        if let emailVerificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? EmailVerificationViewController {
            emailVerificationVC.isErrorEmailVerification = false
            viewController.navigationController?.pushViewController(emailVerificationVC, animated: true)
        }
        
//        if let window = AppDelegate.getWindow() {
//
//            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
//            let indentifier = ViewControllers.dashboardVC.rawValue
//
//            if let dashoboardVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
//                window.rootViewController = dashoboardVC
//            }
//        }
    }
    
    func didOpenDashboardWithOutPromo() {
        viewController.hideSpinner()
        
        
                if let window = AppDelegate.getWindow() {
        
                    let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
                    let indentifier = ViewControllers.dashboardVC.rawValue
        
                    if let dashoboardVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
                        window.rootViewController = dashoboardVC
                    }
                }
    }
    
    
    func presentPreviousVC() {
        viewController.navigationController?.popToRootViewController(animated: true)
       
    }

}
