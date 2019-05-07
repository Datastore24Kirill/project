//
//  TaskStepTableView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 23/04/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TaskStepTableView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderRate: UILabel!
    @IBOutlet weak var orderLevel: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var heightOfNextButton: NSLayoutConstraint!
    
    func localizationView() {
        screenTitle.text = "TaskStepTable.ScreenTitle".localized()
        nextButton.setTitle("TaskStepTable.NextButton".localized(), for: .normal)
        
    }
    
    
    
}
