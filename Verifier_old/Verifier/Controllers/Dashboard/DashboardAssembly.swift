//
//  VerifiAssembly.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class DashboardAssembly: NSObject {
    
    static let sharedInstance = DashboardAssembly()
    
    func configure(_ viewController: DashboardViewController) {
        let requestManeger = RequestHendler()
        let presenter = DashboardPresenter()
        let router = DashboardRouting()
        let interactor = DashboardInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
