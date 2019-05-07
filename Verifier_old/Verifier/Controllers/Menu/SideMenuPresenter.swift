//
//  PublicProfileFTPresenter.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit
import CoreLocation

protocol SideMenuPresenterOutput: class {
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D)
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect, navTitle: String)
}

class SideMenuPresenter: SideMenuViewControllerOutput, SideMenuInteractorOutput {
    
//    func didOpenTaskDetailVC(with task: Task) {
//        router.didOpenDashboardDetailVC(with: task, rect: <#T##CGRect#>)
//    }

    var router: SideMenuPresenterOutput!
    weak var view: SideMenuViewControllerInput!
    var interactor: SideMenuInteractorInput!
    
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect,  navTitle: String) {
        self.router.didOpenDashboardDetailVC(with: task, rect: rect, navTitle: navTitle)
    }
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D) {
        self.router.didOpenTaskDetailVC(with: task, coordinate: coordinate)
    }
    
    func fetchTasks(orderType: OrderTypeRequest) {
        interactor.fetchTasks(orderType: orderType)
    }
    
    func fetchCoordinate(with nameCity: String) {
        interactor.fetchCoordinate(with: nameCity)
    }
    
    func provideTasks(with tasks: [Task], result: ResponseResult) {
        view.provideTasks(with: tasks, result: result)
    }
    
    func provideCoordinate(with res: ServerResponse<Place>) {
        view.provideCoordinate(with: res)
    }
    
}
