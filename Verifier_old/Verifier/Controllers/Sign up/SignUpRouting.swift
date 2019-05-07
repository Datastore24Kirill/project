//
//  SignUpRouting.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SignUpRouting: SignUpPresenterOutput {
    
    weak var viewController: SignUpViewController!

    func didOpenSignUpStepTwoVC(user: User) {
        let storyboard = InternalHelper.StoryboardType.signUpStepTwo.getStoryboard()
        let indentifier = ViewControllers.signUpStepTwoVC.rawValue
        
        if let signUpStepTwoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignUpStepTwoViewController {
            signUpStepTwoVC.user = user
            viewController.navigationController?.pushViewController(signUpStepTwoVC, animated: true)
        }
    }
    
    func didOpenDashboardVC() {
        viewController.hideSpinner()
        if let window = AppDelegate.getWindow() {
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.dashboardVC.rawValue
            
            if let dashoboardVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
                window.rootViewController = dashoboardVC
            }
        }
    }
    
    func presentQRCodeVC() {
        viewController.hideSpinner()
        
        let storyboard = InternalHelper.StoryboardType.qrCode.getStoryboard()
        let indentifier = ViewControllers.qrCodeVC.rawValue
        
        if let qrCodeVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? QRCodeViewController {
            viewController.navigationController?.pushViewController(qrCodeVC, animated: true)
        }
    }
    
    func presentPreviousVC() {
        viewController.hideSpinner()
        
        
        viewController.hideSpinner()
        
        let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
        let indentifier = ViewControllers.signInVC.rawValue
        
        if let qrCodeVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignInViewController {
            viewController.navigationController?.pushViewController(qrCodeVC, animated: false)
        }
    }
}
