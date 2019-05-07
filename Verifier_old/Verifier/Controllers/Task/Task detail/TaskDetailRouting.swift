//
//  TaskDetailRouting.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class TaskDetailRouting: TaskDetailPresenterOutput {
    
    weak var viewController: TaskDetailViewController!
    
    func didOpenDashboardVC() {
        for controller in (self.viewController.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                _ = self.viewController.navigationController?.popToViewController(dashboardVC, animated: true)
                return
            }
        }
    }
}
