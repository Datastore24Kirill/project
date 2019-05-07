//
//  QRCodeAssembly.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class QRCodeAssembly: NSObject {
    
    static let sharedInstance = QRCodeAssembly()
    
    func configure(_ viewController: QRCodeViewController) {
        let presenter = QRCodePresenter()
        let router = QRCodeRouting()
        let interactor = QRCodeInteractor()
        let requestManeger = RequestHendler()
        interactor.apiRequestManager = requestManeger
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = viewController
    }
}
