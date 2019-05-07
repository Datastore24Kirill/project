//
//  TaskInfoView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 22/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TaskInfoView: UIView {

    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderRate: UILabel!
    @IBOutlet weak var orderLevel: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    //MARK: - SCROLLVIEWDATA
    @IBOutlet weak var taskInfoHeaderLabel: UILabel!
    @IBOutlet weak var taskInfoLabel: UILabel!
    @IBOutlet weak var taskAddressHeaderLabel: UILabel!
    @IBOutlet weak var taskAddressLabel: UILabel!
    @IBOutlet weak var datesHeaderLabel: UILabel!
    @IBOutlet weak var verifTimeToHeaderLabel: UILabel!
    @IBOutlet weak var verifTimeToLabel: UILabel!
    @IBOutlet weak var verifTimeToDaysHeaderLabel: UILabel!
    @IBOutlet weak var verifTimeToDaysLabel: UILabel!
    @IBOutlet weak var customerNameHeaderLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var heightOfNexButton: NSLayoutConstraint!
    
    
    
    
    
    func localizationView() {
        
        taskInfoHeaderLabel.text = "Task.Info".localized()
        taskAddressHeaderLabel.text = "Task.Address".localized()
        datesHeaderLabel.text = "Task.Dates".localized()
        verifTimeToHeaderLabel.text = "Task.verifTimeTo".localized()
        verifTimeToDaysHeaderLabel.text = "Task.verifTimeToDays".localized()
        customerNameHeaderLabel.text = "Task.customerName".localized()
        nextButton.setTitle("Task.getOrder".localized(), for: .normal)
        statusView.layer.cornerRadius = 5
        
    }
}
