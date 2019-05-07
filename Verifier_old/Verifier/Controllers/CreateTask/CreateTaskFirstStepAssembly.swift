//
//  CreateTaskFirstStepAssembly.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 01.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class CreateTaskFirstStepAssembly: NSObject {

    static let sharedInstance = CreateTaskFirstStepAssembly()
    
    func configure(_ viewController: CreateTaskFirstStepViewController) {
        let requestManeger = RequestHendler()
        let presenter = CreateTaskFirstStepPresenter()
        let router = CreateTaskFirstStepRouting()
        let interactor = CreateTaskFirstStepInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
