//
//  VerifiPresenter.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps

protocol DashboardPresenterOutput: class {
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D, isMyOrder: Bool)
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect)
    func didOpenSideMenuVC()
    func didOpenLoginVC()
    func didOpenFilterVC()
}

class DashboardPresenter: DashboardViewControllerOutput, DashboardInteractorOutput {
    
    var router: DashboardPresenterOutput!
    weak var view: DashboardViewControllerInput!
    var interactor: DashboardInteractorInput!
    
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect) {
        self.router.didOpenDashboardDetailVC(with: task, rect: rect)
    }
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D, isMyOrder: Bool) {
        self.router.didOpenTaskDetailVC(with: task, coordinate: coordinate, isMyOrder: isMyOrder)
    }
    
    func didOpenMenuSideVC() {
        self.router.didOpenSideMenuVC()
    }
    
    func getVerifierUser() {
        interactor.getVerifierUser()
    }
    
    func fetchTasks() {
        interactor.fetchTasks()
    }
    
    func fetchLogout() {
        interactor.fetchLogout()
    }
    
    func presentFilter() {
        router.didOpenFilterVC()
    }
    
    func fetchCoordinate(with nameCity: String) {
        interactor.fetchCoordinate(with: nameCity)
    }
    
    func provideTasks(with tasks: [Task], result: ResponseResult) {
        self.view.provideTasks(with: tasks, result: result)
    }
    
    func provideCoordinate(with res: ServerResponse<Place>) {
        view.provideCoordinate(with: res)
    }
    
    func provideGetUserResult(with result: ResponseResult) {
        view.provideGetUserResult(with: result)
    }
    
    func provideUserLogoutResult(with result: ResponseResult) {
        view.provideUserLogoutResult(with: result)
    }
    
    func didOpenLoginVC() {
        router.didOpenLoginVC()
    }
    
    func updateUser(with password: String) {
        interactor.updateUser(with: password)
    }
    
    func dashboardViewShowAlert(with: String, message: String) {
        dashboardViewHideSpinner()
        view.dashboardViewShowAlert(with: with, message: message)
    }

    func dashboardViewHideSpinner() {
        view.dashboardViewHideSpinner()
    }
}
