//
//  EmailVerificationRouting.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 21/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class EmailVerificationRouting: EmailVerificationPresenterOutput {

    
  
    
    weak var viewController: EmailVerificationViewController!
    func presentLoginVC() {
        viewController.hideSpinner()
        
        let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
        let indentifier = ViewControllers.signInVC.rawValue
        
        if let signInVerificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignInViewController {
           
            viewController.navigationController?.pushViewController(signInVerificationVC, animated: true)
        }
    }
    
    func presentResendEmailVerifiaction() {
        viewController.hideSpinner()
        
        let storyboard = InternalHelper.StoryboardType.emailVerification.getStoryboard()
        let indentifier = ViewControllers.emailVerificationVC.rawValue
        
        if let emailVerificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? EmailVerificationViewController {
            emailVerificationVC.isErrorEmailVerification = false
            viewController.navigationController?.pushViewController(emailVerificationVC, animated: true)
        }
    }
    
}
