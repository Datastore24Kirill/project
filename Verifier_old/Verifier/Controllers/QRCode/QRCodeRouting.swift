//
//  QRCodeRouting.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol QRCodeRoutingOutput {
    
}

class QRCodeRouting: QRCodePresenterOutput {
    
    weak var viewController: QRCodeViewController!
    
    func presentDashboardVC() {
        viewController.hideSpinner()
        if let window = AppDelegate.getWindow() {
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.dashboardVC.rawValue
            
            if let dashoboardNVVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
                if let dashoboardVC = dashoboardNVVC.topViewController as? DashboardViewController {
                    dashoboardVC.needSetPassword = true
                }
                window.rootViewController = dashoboardNVVC
            }
        }
    }
    
    func presentPreviousVC() {
        viewController.navigationController?.popViewController(animated: true)
    }
}
