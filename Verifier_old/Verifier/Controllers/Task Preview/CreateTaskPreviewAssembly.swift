//
//  CreateTaskPreviewAssembly.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class CreateTaskPreviewAssembly: NSObject {

    static let sharedInstance = CreateTaskPreviewAssembly()

    func configure(_ viewController: CreateTaskPreviewViewController) {
        let requestManeger = RequestHendler()
        let presenter = CreateTaskPreviewPresenter()
        let router = CreateTaskPreviewRouting()
        let interactor = CreateTaskPreviewInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
