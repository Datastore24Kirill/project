//
//  PromoAssembly.swift
//  Verifier
//
//  Created by Кирилл on 14/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class PromoAssembly: NSObject {
    
    static let sharedInstance = PromoAssembly()
    
    func configure(_ viewController: PromoViewController) {

        let presenter = PromoPresenter()
        let router = PromoRouting()
        let interactor = PromoInteractor()
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
        presenter.router = router
       
        
    }
}
