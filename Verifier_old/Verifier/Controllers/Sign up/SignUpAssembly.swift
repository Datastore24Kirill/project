//
//  SignUpAssembly.swift
//  Verifier
//
//  Created by iPeople on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SignUpAssembly: NSObject {
    
    static let sharedInstance = SignUpAssembly()
    
    func configure(_ viewController: SignUpViewController) {
        let requestManeger = RequestHendler()
        let presenter = SignUpPresenter()
        let router = SignUpRouting()
        let interactor = SignUpInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
