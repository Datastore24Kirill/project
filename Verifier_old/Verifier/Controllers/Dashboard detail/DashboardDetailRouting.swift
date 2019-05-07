//
//  DashboardDetailRouting.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps

class DashboardDetailRouting: DashboardDetailPresenterOutput {
    
    weak var viewController: DashboardDetailViewController!
    
    enum ViewControllers: String {
        case selfieViewController = "SelfieVC"
        case taskDetailViewController = "TaskDetailVC"
    }
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D) {

        guard let controller = R.storyboard.settings.createTaskPreviewVC() else { return }

        controller.orderId = task.id
        controller.newOrder.ordetType = .inProgress
        controller.fromDashboard = true

        viewController.addChildViewController(controller)

        controller.view.frame = UIScreen.main.bounds

        viewController.view.addSubview(controller.view)

        controller.didMove(toParentViewController: viewController)
        //self.viewController.navigationController?.pushViewController(controller, animated: true)
        /*
        let controller = InternalHelper.StoryboardType.task.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.taskDetailViewController.rawValue) as! TaskDetailViewController
        
        controller.task = task
        controller.coordinate = coordinate
        controller.fromDashboard = false
        
        viewController.addChildViewController(controller)
        
        controller.view.frame = UIScreen.main.bounds
        
        viewController.view.addSubview(controller.view)
        
        controller.didMove(toParentViewController: viewController)
        */
    }
}
