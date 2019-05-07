//
//  FogotPasswordAssembly.swift
//  Verifier
//
//  Created by Кирилл on 16/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

import UIKit

class ForgotPasswordAssembly: NSObject {
    
    static let sharedInstance = ForgotPasswordAssembly()
    
    func configure(_ viewController: FogotPasswordViewController) {
        let requestManeger = RequestHendler()
        let presenter = FogotPasswordPresenter()
        let router = FogotPasswordRouting()
        let interactor = FogotPasswordInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
    }
}
