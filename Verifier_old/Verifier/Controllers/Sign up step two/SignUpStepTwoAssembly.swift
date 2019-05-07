//
//  SignUpStepTwoAssembly.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class SignUpStepTwoAssembly: NSObject {
    
    static let sharedInstance = SignUpStepTwoAssembly()
    
    func configure(_ viewController: SignUpStepTwoViewController) {
        let requestManeger = RequestHendler()
        let presenter = SignUpStepTwoPresenter()
        let router = SignUpStepTwoRouting()
        let interactor = SignUpStepTwoInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
