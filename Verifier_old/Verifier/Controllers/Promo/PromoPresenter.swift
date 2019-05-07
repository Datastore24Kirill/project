//
//  PromoPresenter.swift
//  Verifier
//
//  Created by Кирилл on 14/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol PromoPresenterOutput: class {
    
    func presentDashboardVC()
}

class PromoPresenter: PromoViewControllerOutput, PromoInteractorOutput {
    
    var router: PromoPresenterOutput!
    var interactor: PromoInteractorInput!
   
    func presentDashboardVC() {
        router.presentDashboardVC()
    }
    
    
}
