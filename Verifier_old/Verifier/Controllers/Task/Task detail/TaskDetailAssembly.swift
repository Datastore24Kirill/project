//
//  TaskDetailAssembly.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class TaskDetailAssembly {
    
    static let sharedInstance = TaskDetailAssembly()
    
    func configure(_ viewController: TaskDetailViewController) {
        let requestManeger = RequestHendler()
        let presenter = TaskDetailPresenter()
        let router = TaskDetailRouting()
        let interactor = TaskDetailInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
