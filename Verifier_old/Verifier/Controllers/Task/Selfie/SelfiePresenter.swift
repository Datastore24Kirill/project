//
//  PublicProfileFTPresenter.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

protocol SelfiePresenterOutput: class {
    func didOpenDashboardVC()
}

class SelfiePresenter: SelfieViewControllerOutput, SelfieInteractorOutput {
    
    var router: SelfiePresenterOutput!
    weak var view: SelfieViewControllerInput!
    var interactor: SelfieInteractorInput!
    
    func didOpenDashboardVC() {
        self.router.didOpenDashboardVC()
    }
    
    func getTaskData(taskId: Int) {
        self.interactor.getTaskData(taskId: taskId)
    }
    
    func provideDataTask(success: Bool, task: Task?, error: [String: Any]?) {
        self.view.provideDataTask(success: success, task: task, error: error)
    }
}
