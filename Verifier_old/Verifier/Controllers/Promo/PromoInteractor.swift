//
//  PromoInteractor.swift
//  Verifier
//
//  Created by Кирилл on 14/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol PromoInteractorInput: class {
    func didShowDashboardVc()
}

protocol PromoInteractorOutput: class {
    
    func presentDashboardVC()
    
}

class PromoInteractor {
    
    weak var presenter: PromoInteractorOutput!

    
    func didShowDashboardVc() {
        
        self.presenter.presentDashboardVC()
        
        
    }
    
}
