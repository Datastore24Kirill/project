//
//  VerifierAppDefaultNavigationViewController.swift
//  Verifier
//
//  Created by Mac on 4/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol DashboardNavigationViewControllerProtocol {
    typealias Item = DashboardNavigationViewController.Item
    func openMenuItem(with item: Item)
}

class DashboardNavigationViewController: UINavigationController {

    enum Item {
        case personalArea
        case createNewOrder
        case verifyOrder
        case myTasks
        case taskOnVerification
        case filters
        case settings
        case jivosite
        
        func getOpenItem(with navController: DashboardNavigationViewController) {
            switch self {
            case .personalArea: navController.openPersonalArea()
            case .verifyOrder: navController.openVerifyOrder()
            case .createNewOrder: navController.openCreateNewOrder()
            case .myTasks:
                navController.openMyTasks()
            case .taskOnVerification: navController.openTaskOnVerification()
            case .filters: navController.openFilters()
            case .settings: navController.openSettings()
            case .jivosite: navController.openJivoSite()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Methods
    func openMenu() {
        guard let controller = R.storyboard.menu.rightSideMenuVC() else { return }
        controller.delegate = self
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        AppDelegate.topMostController().present(controller, animated: false)
    }
    
    //MARK: Personal Area
    private func openPersonalArea() {
        guard let controller = R.storyboard.profile.profileVC() else { return }
        viewControllers = [controller]
    }

    //MARK: Verify Order
    private func openVerifyOrder() {
        guard let controller = R.storyboard.menu.sideMenuVC() else { return }
        controller.orderType = .verifyOrder
        viewControllers = [controller]
    }

    //MARK: Create New Order
    private func openCreateNewOrder() {
        guard let controller = R.storyboard.settings.createTaskFirstStepVC() else { return }
        //guard let controller = R.storyboard.createTaskStepTwo.createTaskTwo() else { return }
        viewControllers = [controller]
    }
    
    //MARK: My Tasks
    private func openMyTasks() {
        guard let controller = R.storyboard.menu.sideMenuVC() else { return }
        controller.orderType = .myOrder
        viewControllers = [controller]
    }
    
    //MARK: Task On Verification
    private func openTaskOnVerification() {
        guard let controller = R.storyboard.dashboard.dashboardVC() else { return }
        viewControllers = [controller]
    }
    
    //MARK: Filters
    private func openFilters() {
        guard let controller = R.storyboard.filter.filterVC() else { return }
        viewControllers = [controller]
    }
    
    //MARK: Settings
    private func openSettings() {
        guard let controller = R.storyboard.settings.settingsVC() else { return }
        viewControllers = [controller]
    }
    
    //MARK: JivoSite
    private func openJivoSite() {
        guard let controller = R.storyboard.jivoSite.jivoSiteVC() else { return }
        viewControllers = [controller]
    }

}

//MARK: - DashboardNavigationViewControllerProtocol
extension DashboardNavigationViewController: DashboardNavigationViewControllerProtocol {

    func openMenuItem(with item: DashboardNavigationViewControllerProtocol.Item) {
        dismiss(animated: false) { [weak self] in
            if let nav = self {
                item.getOpenItem(with: nav)
            }
        }
    }
}
