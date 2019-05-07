//
//  DashboardDetailPresenter.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps

protocol DashboardDetailPresenterOutput: class {
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D)
}

class DashboardDetailPresenter: DashboardDetailViewControllerOutput, DashboardDetailInteractorOutput {
    
    var router: DashboardDetailPresenterOutput!
    weak var view: DashboardDetailViewControllerInput!
    var interactor: DashboardDetailInteractorInput!
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D) {
        self.router.didOpenTaskDetailVC(with: task, coordinate: coordinate)
    }
    
    func fetchChangeTask(with id: Int, param: [String : Any]) {
        interactor.fetchChangeTask(with: id, param: param)
    }
    
//    func fetchCoordinate(with nameCity: String) {
//        interactor.fetchCoordinate(with: nameCity)
//    }
    
    func provideResultChangeTask(with result: ResponseResult) {
        self.view.provideResultChangeTask2(with: result)
    }
    
//    func provideCoordinate(with coordinate: CLLocationCoordinate2D?, result: ResponseResult) {
//        view.provideCoordinate(with: coordinate, result: result)
//    }
    
    func provideError() {
        self.view.provideError()
    }
}
