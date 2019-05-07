//
//  IdDataCollectionViewCell.swift
//  Verifier
//
//  Created by Mac on 16.02.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class IdDataCollectionViewCell: DefaultProfileCollectionViewCell {

    @IBOutlet weak var issueTextField: UITextField!
    @IBOutlet weak var issueDateTextFiled: UITextField!
    @IBOutlet weak var issueCodeTextField: UITextField!
    @IBOutlet weak var passportSeriesTextField: UITextField!
    @IBOutlet weak var passportNumberTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLocalization()
        setValues()
    }
    
    func setLocalization() {
        issueTextField.placeholder = "Passport issue".localized()
        issueDateTextFiled.placeholder = "Passport issue date".localized()
        issueCodeTextField.placeholder = "Passport issue code".localized()
        passportSeriesTextField.placeholder = "Passport series".localized()
        passportNumberTextField.placeholder = "Passport number".localized()
    }
    
    func setValues() {
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        if let value = user.issue {
            issueTextField.text = value
        }
        
        if let value = user.issueCode {
            issueCodeTextField.text = String(value)
        }
        
        if let value = user.issueDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            let date = Date(timeIntervalSince1970: TimeInterval(value))
            
            issueDateTextFiled.text = dateFormatter.string(from: date)
            
        }
        
        if let value = user.passportSeries {
            passportSeriesTextField.text = value
        }
        
        if let value = user.passportNumber {
            passportNumberTextField.text = String(value)
        }
    }
    
    @IBAction func profileTextFieldsAction(_ sender: UITextField) {
        
        switch sender {
        case issueTextField:
            if self.issueTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.issue = self.issueTextField.text!
            }
        case issueCodeTextField:
            if self.issueCodeTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.issueCode = Int(self.issueCodeTextField.text!)!
            }
        case passportSeriesTextField:
            if self.passportSeriesTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.passportSeries = self.passportSeriesTextField.text!
            }
        case passportNumberTextField:
            if self.passportNumberTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.passportNumber = Int(self.passportNumberTextField.text!)!
            }
        default: break
        }
        
    }
    
    @IBAction func didPressIssueDateButton(_ sender: UIButton) {
        self.delegate?.didOpenDatePickerView(type: .issue)
    }

}
