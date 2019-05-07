//
//  EmailVerificationAssembly.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 21/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class EmailVerificationAssembly: NSObject {
    
    static let sharedInstance = EmailVerificationAssembly()
    
    func configure(_ viewController: EmailVerificationViewController) {
        
        
        let requestManeger = RequestHendler()
        let presenter = EmailVerificationPresenter()
        let router = EmailVerificationRouting()
        let interactor = EmailVerificationInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
        
    }
}
