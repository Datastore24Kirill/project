//
//  FogotPasswordRouter.swift
//  Verifier
//
//  Created by Кирилл on 16/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FogotPasswordRouting: FogotPasswordPresenterOutput {
    
    weak var viewController: FogotPasswordViewController!
    
    func presentPreviousVC() {
        print("back")
        viewController.navigationController?.popViewController(animated: true)
    }
    
}

