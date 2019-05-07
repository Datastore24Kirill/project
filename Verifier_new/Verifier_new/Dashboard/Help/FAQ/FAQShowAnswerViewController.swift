//
//  FAQShowAnswerViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class  FAQShowAnswerViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var showAnswerView: FAQShowAnswerView!
    
    //MARK: - PROPERTIES
    var screenTitle: String?
    var questionLabel: String?
    var answerLabel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnswerView.screenTitle.text = screenTitle ?? "FAQ".localized()
        showAnswerView.questionLabel.text = questionLabel ?? ""
        showAnswerView.answerLabel.text = answerLabel ?? ""
        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
