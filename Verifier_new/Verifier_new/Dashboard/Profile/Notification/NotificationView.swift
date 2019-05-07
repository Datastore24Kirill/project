//
//  NotificationView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var readAllButton: UIButton!
    @IBOutlet weak var readAllLabel: UILabel!
    
    func localizationView() {
        screenTitle.text = "Notification.ScreenTitle".localized()
        readAllLabel.text = "Notification.ReadAll".localized()
    }
}

