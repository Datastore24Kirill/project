//
//  SettingsAssembly.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 23.04.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SettingsAssembly: NSObject {
    
    static let sharedInstance = SettingsAssembly()
    
    func configure(_ viewController: SettingsViewController) {
        let requestManeger = RequestHendler()
        let presenter = SettingsPresenter()
        let router = SettingsRouting()
        let interactor = SettingsInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
