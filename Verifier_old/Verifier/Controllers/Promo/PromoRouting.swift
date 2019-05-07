//
//  PromoRouting.swift
//  Verifier
//
//  Created by Кирилл on 14/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class PromoRouting: PromoPresenterOutput {
    weak var viewController: PromoViewController!
    func presentDashboardVC() {
        viewController.hideSpinner()
        if let window = AppDelegate.getWindow() {
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.dashboardVC.rawValue
            
            if let dashoboardVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
                window.rootViewController = dashoboardVC
            }
        }
    }

}
