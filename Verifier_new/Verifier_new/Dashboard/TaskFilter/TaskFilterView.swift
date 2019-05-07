//
//  TaskFilterView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TaskFilterView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var priceDropDownView: UIView!
    @IBOutlet weak var priceSortLabel: UILabel!
    @IBOutlet weak var priceDropDownLabel: UILabel!
    @IBOutlet weak var priceDropDownButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    //TimeOUTLETS
    @IBOutlet weak var timeToAllLabel: UILabel!
    @IBOutlet weak var timeToAllView: UIView!
    @IBOutlet weak var timeToAllIcon: UIImageView!
    
    @IBOutlet weak var timeToTodayLabel: UILabel!
    @IBOutlet weak var timeToTodayView: UIView!
    @IBOutlet weak var timeToTodayIcon: UIImageView!
    
    @IBOutlet weak var timeTo24HoursLabel: UILabel!
    @IBOutlet weak var timeTo24HoursView: UIView!
    @IBOutlet weak var timeTo24HoursIcon: UIImageView!

    
    
    
    //

    
    func localizationView() {
        
        priceDropDownView.layer.cornerRadius = 5
        priceDropDownView.layer.borderColor = UIColor.gray.cgColor
        priceDropDownView.layer.borderWidth = 1
        priceDropDownLabel.text = "Отключен".localized()
        
        
        
    }
}
