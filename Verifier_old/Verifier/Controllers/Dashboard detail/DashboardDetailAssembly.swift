//
//  DashboardDetailAssembly.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class DashboardDetailAssembly: NSObject {
    
    static let sharedInstance = DashboardDetailAssembly()
    
    func configure(_ viewController: DashboardDetailViewController) {
        let requestManeger = RequestHendler()
        let presenter = DashboardDetailPresenter()
        let router = DashboardDetailRouting()
        let interactor = DashboardDetailInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
