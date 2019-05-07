//
//  InstructionViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 29/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class InstructionViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var instructionView: InstructionView!

    //MARK: - PROPERTIES
    var htmlString: String?
    var showNextButton = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         instructionView.localizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        if htmlString != nil {
            instructionView.webView.loadHTMLString(htmlString!, baseURL: nil)
        }
        
        
        if showNextButton {
            instructionView.nextButton.alpha = 1
            instructionView.isUserInteractionEnabled = true
            instructionView.nextButtonHeight.constant = 50.0
        }
        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
    }
    
    
    

}
