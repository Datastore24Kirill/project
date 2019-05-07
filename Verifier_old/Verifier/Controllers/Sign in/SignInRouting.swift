//
//  SignInRouting.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SignInRouting: SignInPresenterOutput {
    
    weak var viewController: SignInViewController!
    
    func didOpenDashboardVC() {
        viewController.hideSpinner()
        if let window = AppDelegate.getWindow() {
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.dashboardVC.rawValue
            
            if let dashoboardNVVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
                window.rootViewController = dashoboardNVVC
            }
        }
    }
    
    func didOpenSignUpVC() {
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.signUpVC.rawValue
        
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignUpViewController {
            viewController.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    func didPresentEmailVerificationVC(email: String) {
        
        let storyboard = InternalHelper.StoryboardType.emailVerification.getStoryboard()
        let indentifier = ViewControllers.emailVerificationVC.rawValue
        
        if let emailVerificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? EmailVerificationViewController {
            emailVerificationVC.isErrorEmailVerification = true
            emailVerificationVC.emailSting = email
            viewController.navigationController?.pushViewController(emailVerificationVC, animated: true)
        }
        
    }
    
    func didOpenEnterPasswordVC() {
        let storyboard = InternalHelper.StoryboardType.signUpStepTwo.getStoryboard()
        let indentifier = ViewControllers.signUpStepTwoVC.rawValue
        
        if let signUpStepTwoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignUpStepTwoViewController {
            signUpStepTwoVC.isResetPassword = true
            viewController.navigationController?.pushViewController(signUpStepTwoVC, animated: true)
        }
    }
    
    func didOpenForgotPasswordVC() {
        let storyboard = InternalHelper.StoryboardType.fogotPassword.getStoryboard()
        let indentifier = ViewControllers.FogotPasswordVC.rawValue
        
        if let fogotPasswordVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? FogotPasswordViewController {
            viewController.navigationController?.pushViewController(fogotPasswordVC, animated: true)
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

}
