//
//  PublicProfileFTAssembly.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

class SideMenuAssembly: NSObject {
    
    static let sharedInstance = SideMenuAssembly()
    
    func configure(_ viewController: SideMenuViewController) {
        let requestManeger = RequestHendler()
        let presenter = SideMenuPresenter()
        let router = SideMenuRouting()
        let interactor = SideMenuInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
