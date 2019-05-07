//
//  SignUpStepTwoView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol SignUpStepTwoViewDelegate: class {
    func showDatePicker()
    func registration(params: [String:String])
    func showAlertError(with title: String?, message: String?)
}


class SignUpStepTwoView: UIView {

    //MARK:- Delegate
    weak var delegate: SignUpStepTwoViewDelegate?
    
    //MARK: - OUTLETS
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var birthdayTextView: UITextView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var policyTextView: UITextView!
 
    var isMan = true
    var birthdayTimeStamp: String?
    
    func localizationView() {
        screenTitle.text = "Registration.StepTwo".localized()
        registrationButton.setTitle("Registered".localized(), for: .normal)
        startLabel.text = "Registration.StepTwo.StartText".localized()
        birthdayTextView.text = "Registration.StepTwo.Birthday".localized()
        genderLabel.text = "Registration.StepTwo.Gender".localized()
        manButton.setTitle("Registration.StepTwo.Man".localized(), for: .normal)
        womanButton.setTitle("Registration.StepTwo.Woman".localized(), for: .normal)
        changeColorGenderButton()
    }
    
    func changeColorGenderButton() {
        if isMan {
            manButton.layer.backgroundColor = UIColor("#c5ced3").cgColor
            womanButton.layer.backgroundColor = UIColor("#f0f4f7").cgColor
        } else {
            manButton.layer.backgroundColor = UIColor("#f0f4f7").cgColor
            womanButton.layer.backgroundColor = UIColor("#c5ced3").cgColor
        }
    }
    
    @IBAction func manButtonAction(_ sender: Any) {
        isMan = true
        changeColorGenderButton()
    }
    
    @IBAction func womanButtonAction(_ sender: Any) {
        isMan = false
        changeColorGenderButton()
    }
    
    @IBAction func birthdayButtonAction(_ sender: Any) {
        print("pickerSHOW")
        self.delegate?.showDatePicker()
    }
    
    
    @IBAction func registrationButtonAction(_ sender: Any) {
        var params = [String:String]()
        
        
        guard let birthdate = birthdayTextView.text, birthdate != "Registration.StepTwo.Birthday".localized().localized()
                else {
                    self.delegate?.showAlertError(with: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        let gender = isMan ? "1" : "2"
        params["gender"] = gender
        params["birthday"] = birthdayTimeStamp
        
        self.delegate?.registration(params: params)
       
    }
    
    
}

