//
//  PublicProfileFTAssembly.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

class SelfieAssembly {
    
    static let sharedInstance = SelfieAssembly()
    
    func configure(_ viewController: SelfieViewController) {
        let requestManeger = RequestHendler()
        let presenter = SelfiePresenter()
        let router = SelfieRouting()
        let interactor = SelfieInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
