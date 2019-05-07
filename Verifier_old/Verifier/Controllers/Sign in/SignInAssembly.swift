//
//  SignInAssembly.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SignInAssembly: NSObject {
    
    static let sharedInstance = SignInAssembly()
    
    func configure(_ viewController: SignInViewController) {
        let requestManeger = RequestHendler()
        let presenter = SignInPresenter()
        let router = SignInRouting()
        let interactor = SignInInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
