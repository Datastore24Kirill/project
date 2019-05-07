//
//  PublicProfileFTRouting.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit
import CoreLocation

class SideMenuRouting: SideMenuPresenterOutput {
    
    enum ViewControllers: String {
        case dashboardDetailActiveVC = "DashboardDetailActiveVC"
        case taskDetailViewController = "TaskDetailVC"
        case dashboardDetailVC = "DashboardDetailVC"
        case sideMenuVC = "SideMenuVC"
    }
    
    weak var viewController: SideMenuViewController!
    
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect, navTitle: String) {
        
        let vc = ViewControllers.dashboardDetailVC.rawValue
        
        let controller = InternalHelper.StoryboardType.detail.getStoryboard().instantiateViewController(withIdentifier: vc) as! DashboardDetailViewController
        controller.task = task
        controller.floatViewRect = rect
        
        self.viewController.navigationController?.pushViewController(controller, animated: false)

        
//        guard let controller = R.storyboard.settings.createTaskPreviewVC() else { return }
//
//        controller.fromDashboard = true
//        controller.orderStatus = task.status
//        controller.orderId = task.id
//        controller.navTitle = navTitle
//    self.viewController.navigationController?.pushViewController(controller, animated: true)

        /*
        let vc = task.status == 2 ? ViewControllers.dashboardDetailActiveVC.rawValue :
            ViewControllers.dashboardDetailVC.rawValue
        
        let controller = InternalHelper.StoryboardType.detail.getStoryboard().instantiateViewController(withIdentifier: vc) as! DashboardDetailViewController
        controller.task = task
        controller.floatViewRect = rect
        
        self.viewController.navigationController?.pushViewController(controller, animated: false)
 */
    }
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D) {

        /*
         2 - ACCEPTED
         3 - VERIFIED
         4 - APPROVED
         */
        
        guard let controller = R.storyboard.settings.createTaskPreviewVC() else { return }

        controller.orderId = task.id
        controller.newOrder.ordetType = .inProgress
        controller.orderStatus = task.status
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
}
