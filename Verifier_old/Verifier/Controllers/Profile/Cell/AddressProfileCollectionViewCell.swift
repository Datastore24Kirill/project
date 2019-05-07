//
//  AddressProfileCollectionViewCell.swift
//  Verifier
//
//  Created by Mac on 16.02.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class AddressProfileCollectionViewCell: DefaultProfileCollectionViewCell {
    
    @IBOutlet weak var addressTypeTextField: UITextField!
    @IBOutlet weak var addressCountryTextField: UITextField!
    @IBOutlet weak var addressRegionTextField: UITextField!
    @IBOutlet weak var addressCityTextField: UITextField!
    @IBOutlet weak var addressStreetTextField: UITextField!
    @IBOutlet weak var addressHouseTextField: UITextField!
    @IBOutlet weak var addressFlatTextField: UITextField!
    @IBOutlet weak var addressZipCodeTextField: UITextField!
    @IBOutlet weak var containerAddressType: ShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLocalization()
        setValues()
    }
    
    func setLocalization() {
        let isLanguageEnglish = InternalHelper.sharedInstance.getCurrentLanguage() == "en"
        containerAddressType.isHidden = isLanguageEnglish
        addressTypeTextField.placeholder = "Address Type".localized()
        addressCountryTextField.placeholder = "Country".localized()
        addressRegionTextField.placeholder = "Region".localized()
        addressCityTextField.placeholder = "City".localized()
        addressStreetTextField.placeholder = "Street".localized()
        addressHouseTextField.placeholder = "House".localized()
        addressFlatTextField.placeholder = "Apartment".localized()
        addressZipCodeTextField.placeholder = "ZIP code".localized()
    }
    
    func setValues() {
        guard let user = UserDefaultsVerifier.getUser() else { return }
        guard let address = user.address else { return }
        
        if let value = address.addressType {
            addressTypeTextField.text = value
        }
        
        if let value = address.country {
            addressCountryTextField.text = value
        }
        
        if let value = address.region {
            addressRegionTextField.text = value
        }
        
        if let value = address.city {
            addressCityTextField.text = value
        }
        
        if let value = address.street {
            addressStreetTextField.text = value
        }
        
        if let value = address.house {
            addressHouseTextField.text = value
        }
        
        if let value = address.flat {
            addressFlatTextField.text = value
        }
        
        if let value = address.zipCode {
            addressZipCodeTextField.text = value
        }
    }
    
    @IBAction func profileTextFieldAction(_ sender: UITextField) {
        
        if User.sharedInstanse.address == nil {
            User.sharedInstanse.address = User.Address()
        }
        
        switch sender {
            
        case addressTypeTextField:
            if InternalHelper.sharedInstance.getCurrentLanguage() == "ru" {
                if self.addressTypeTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                    User.sharedInstanse.address?.addressType = self.addressTypeTextField.text!
                }
            }
            
        case addressCountryTextField:
            if self.addressCountryTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.country = self.addressCountryTextField.text!
            }
            
        case addressRegionTextField:
            if self.addressRegionTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.region = self.addressRegionTextField.text!
            }
            
        case addressCityTextField:
            if self.addressCityTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.city = self.addressCityTextField.text!
            }
            
        case addressStreetTextField:
            if self.addressStreetTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.street = self.addressStreetTextField.text!
            }
            
        case addressHouseTextField:
            if self.addressHouseTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.house = self.addressHouseTextField.text!
            }
            
        case addressFlatTextField:
            if self.addressFlatTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.flat = self.addressFlatTextField.text!
            }
            
        case addressZipCodeTextField:
            if self.addressZipCodeTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
                User.sharedInstanse.address?.zipCode = self.addressZipCodeTextField.text!
            }
            
        default: break
        }
        
    }
    
    @IBAction func didpressAddressTypeButton(_ sender: UIButton) {
        let values = ["Регистрации", "Проживания"]
        self.delegate?.didOpenPickerView(values: values, typeField: .addressType)
    }
    
}
