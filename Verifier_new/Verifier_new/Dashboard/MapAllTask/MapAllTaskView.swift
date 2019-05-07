//
//  MapAllTaskView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class MapAllTaskView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderRate: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var iconEducation: UIImageView!
    @IBOutlet weak var orderLevel: UIImageView!
    
    
    func localizationView() {
        screenTitle.text = "AllTask.ScreenTitle".localized()
    }
}
