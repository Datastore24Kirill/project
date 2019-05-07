//
//  PublicProfileFTRouting.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

class SelfieRouting: SelfiePresenterOutput {
    
    weak var viewController: SelfieViewController!
    
    func didOpenDashboardVC() {
        for controller in (self.viewController.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                _ = self.viewController.navigationController?.popToViewController(dashboardVC, animated: true)
                return
            }
        }
    }
}
