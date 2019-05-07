//
//  TaskDetailPresenter.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol TaskDetailPresenterOutput: class {
    func didOpenDashboardVC()
}

class TaskDetailPresenter: TaskDetailViewControllerOutput, TaskDetailInteractorOutput {
    
    var router: TaskDetailPresenterOutput!
    weak var view: TaskDetailViewControllerInput!
    var interactor: TaskDetailInteractorInput!
    
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
