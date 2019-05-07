//
//  SignInView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import SwiftPullToRefresh

class SignInView: UIView {
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var noUserLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    func localizationView(didShowBackButton: Bool) {
        screenTitle.text = "SignIn".localized()
        emailTextField.placeholder = "Email".localized()
        passwordTextField.placeholder =  "Password".localized()
        resetButton.setTitle("FogotPassword".localized(), for: .normal)
        noUserLabel.text = "NoUser".localized()
        registrationLabel.text = "Registration".localized()
        enterButton.setTitle("Enter".localized(), for: .normal)
        if !didShowBackButton {
            backButton.alpha = 0
        } else {
            backButton.alpha = 1
        }
        
        guard
            let url = Bundle.main.url(forResource: "logo_pre", withExtension: "gif"),
            let data = try? Data(contentsOf: url) else { return }
        print("DATA \(data)")
        scrollView.spr_setGIFHeader(data: data, isBig: false, height: 150) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.scrollView.spr_endRefreshing()
            })
        }
        
        
    }
}

