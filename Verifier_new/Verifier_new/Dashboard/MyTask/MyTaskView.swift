//
//  MyTaskView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 25/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import TTSegmentedControl


class MyTaskView: UIView {
    
    //OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var filterControl: TTSegmentedControl!
    
    
    
    
    func localizationView() {
        
        screenTitle.text = "MyTask.ScreenTitle".localized()
        
    }
    
    func setupFilterControl () {
        filterControl.itemTitles.removeAll()
        filterControl.itemTitles = ["status.ACCEPTED".localized(), "status.VERIFIED".localized(), "status.APPROVE".localized(), "status.RETURNEDTOVERIFIER".localized()]
        filterControl.changeTitle("status.ACCEPTED".localized(), atIndex: 0)
        filterControl.changeTitle("status.VERIFIED".localized(), atIndex: 1)
        filterControl.changeTitle("status.APPROVE".localized(), atIndex: 2)
        filterControl.changeTitle("status.RETURNEDTOVERIFIER".localized(), atIndex: 3)
        
        
    }
    
    
}
