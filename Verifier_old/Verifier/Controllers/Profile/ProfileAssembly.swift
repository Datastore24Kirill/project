//
//  ProfileAssembly.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

class ProfileAssembly: NSObject {
    
    static let sharedInstance = ProfileAssembly()
    
    func configure(_ viewController: ProfileViewController) {
        let requestManeger = RequestHendler()
        let presenter = ProfilePresenter()
        let router = ProfileRouting()
        let interactor = ProfileInteractor()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
