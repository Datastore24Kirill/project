//
//  PersonalProfileCollectionViewCell.swift
//  Verifier
//
//  Created by Mac on 16.02.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class PersonalProfileCollectionViewCell: DefaultProfileCollectionViewCell {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var workPlaceTextField: UITextField!
    @IBOutlet weak var specializationTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLocalization()
        setValues()
    }
    
    func setLocalization() {
        firstNameTextField.placeholder = "First name".localized()
        lastNameTextField.placeholder = "Last name".localized()
        phoneNumberTextField.placeholder = "Phone".localized()
        birthDateTextField.placeholder = "Birth date".localized()
        workPlaceTextField.placeholder = "Work Place".localized()
        specializationTextField.placeholder = "Specialization".localized()
        nationalityTextField.placeholder = "Nationality".localized()
    }
    
    func setValues() {
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        if let value = user.firstName {
            firstNameTextField.text = value
        }
        
        if let value = user.lastName {
            lastNameTextField.text = value
        }
        
        if let value = user.phone {
            phoneNumberTextField.text = value
        }
        
        if let value = user.birthDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            let date = Date(timeIntervalSince1970: TimeInterval(value))
            
            birthDateTextField.text = dateFormatter.string(from: date)
        }
        
        if let value = user.companyName {
            workPlaceTextField.text = value
        }
        
        if let value = user.specialization {
            specializationTextField.text = value
        }
        
        if let value = user.passportType {
            nationalityTextField.text = value
        }
        
    }
    
    @IBAction func profileTextFieldsAction(_ sender: UITextField) {
        
        switch sender {
        case firstNameTextField:
            User.sharedInstanse.firstName = firstNameTextField.text!
        case lastNameTextField:
            User.sharedInstanse.lastName = lastNameTextField.text!
        case phoneNumberTextField:
            if self.phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.phone = self.phoneNumberTextField.text!
            }
        case workPlaceTextField:
            if self.workPlaceTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.companyName = self.workPlaceTextField.text!
            }
        case specializationTextField:
            if self.specializationTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.specialization = self.specializationTextField.text!
            }
        default: break
        }
        
    }
    
    @IBAction func didPressBirthdayButton(_ sender: UIButton) {
        self.delegate?.didOpenDatePickerView(type: .birthDay)
    }
    
    @IBAction func didpressNationalityButton(_ sender: UIButton) {
        
        var values = [String]()

        switch InternalHelper.sharedInstance.getCurrentLanguage() {
        case "ru": values = ["США", "РУС"]
        case "en": values = ["USA", "RUS"]
        default: break
        }
        
        self.delegate?.didOpenPickerView(values: values, typeField: .nationality)
    }
    
}
