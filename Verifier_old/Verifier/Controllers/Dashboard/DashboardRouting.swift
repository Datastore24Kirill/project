//
//  VerifiRouting.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps

class DashboardRouting: DashboardPresenterOutput {    
    
    enum ViewControllers: String {
        case dashboardDetailVC = "DashboardDetailVC"
        case dashboardDetailActiveVC = "DashboardDetailActiveVC"
        case taskDetailViewController = "TaskDetailVC"
        case filterVC = "FilterVC"
        case sideMenuVC = "SideMenuVC"
    }
    
    weak var viewController: DashboardViewController!
    
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect) {
        
        let vc = task.status == 2 ? ViewControllers.dashboardDetailActiveVC.rawValue :
        ViewControllers.dashboardDetailVC.rawValue
        
        let controller = InternalHelper.StoryboardType.detail.getStoryboard().instantiateViewController(withIdentifier: vc) as! DashboardDetailViewController
        controller.task = task
        controller.floatViewRect = rect
        
        self.viewController.navigationController?.pushViewController(controller, animated: false)
    }
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D, isMyOrder: Bool) {

        guard let controller = R.storyboard.settings.createTaskPreviewVC() else { return }

        controller.orderId = task.id
        controller.orderStatus = task.status
        controller.newOrder.ordetType = .inProgress
        controller.fromDashboard = true
        self.viewController.navigationController?.pushViewController(controller, animated: true)
        /*
        let controller = InternalHelper.StoryboardType.task.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.taskDetailViewController.rawValue) as! TaskDetailViewController
        
        controller.task = task
        controller.coordinate = coordinate
        controller.fromDashboard = true
        
        self.viewController.navigationController?.pushViewController(controller, animated: false)
 */
        
    }
    
    func didOpenSideMenuVC() {
        let controller = InternalHelper.StoryboardType.menu.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.sideMenuVC.rawValue) as! SideMenuViewController
        
        
        self.viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didOpenFilterVC() {
        guard let controller = R.storyboard.filter.filterVC() else { return }
        
        self.viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    func didOpenLoginVC() {
        if let window = AppDelegate.getWindow() {
            let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginNavVC")
            window.rootViewController = loginVC
        }
    }
}
