//
//  VerifUserStepOneViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 14/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import PopupDialog
import UDatePicker

class VerifUserStepOneViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var midleNameLabel: UITextField!
    @IBOutlet weak var birthdayLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    
    
    //MARK: - PROPERTIES
    var datePicker: UDatePicker?
    var birthdayTimeStamp: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localizationView()
        showStepOnePopup()
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func localizationView() {
        screenTitle.text = "Verification.ScreenTitle".localized()
        nextButton.setTitle("Next".localized(), for: .normal)
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let firstName = firstNameLabel.text, firstName != "",
            let lastName = lastNameLabel.text, lastName != "",
            let midleName = midleNameLabel.text, midleName != "",
            let birthday = birthdayLabel.text, birthday != "",
            let city = cityLabel.text, city != "" else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        

        Singleton.shared.userVerificationData["firstName"] = firstName
        Singleton.shared.userVerificationData["lastName"] = lastName
        Singleton.shared.userVerificationData["middleName"] = midleName
        Singleton.shared.userVerificationData["birthDate"] = birthdayTimeStamp
        Singleton.shared.userVerificationData["birthPlace"] = city
        
        
        print("USER DATA \(Singleton.shared.userVerificationData)")
        
        let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
        let indentifier = ViewControllers.verificationUserStepTwoVC.rawValue
        
        if let verificationUserStepTwoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepTwoViewController {
            self.navigationController?.pushViewController(verificationUserStepTwoVC, animated: true)
            
        }
        
        
        
    }
    
    
    @IBAction func birthdayButtonAction(_ sender: Any) {
        showDatePicker()
    }
    
    
    
    //MARK: - SUPPORT FUNC
    
    func showStepOnePopup(animated: Bool = true) {
        
        // Create a custom view controller
        
        
        // Create the dialog
        let popup = PopupDialog(title: "Ответьте на вопрос", message: "Являетесь ли вы студентом очной формы обучения?", image: nil)
        
        // Create first button
        let buttonOne = DefaultButton(title: "Да", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = CancelButton(title: "Нет", height: 60) {
            
            let action = UIAlertAction(title: "ОК", style: .default) { (_) in
                
                self.navigationController?.popToRootViewController(animated: false)
                
            }
            self.showAlert(title: "", message: "Приносим свои извинения, на данный момент мы не можем оформить вас официально", action: action)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
    func showDatePicker(){
        
        if datePicker == nil  {
            
            datePicker = UDatePicker(frame: verificationView.frame, willDisappear: { date in
                if self.datePicker!.picker.doneButton.isTouchInside {
                    if let resultDate = date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd.MM.YYYY"
                        let birthdayDateString = formatter.string(from: resultDate) // string purpose I add here
                        self.birthdayTimeStamp = String(Int64((resultDate.timeIntervalSince1970).rounded()))
                        self.birthdayLabel.text = birthdayDateString;
                    }
                }
                
            })
            datePicker!.picker.doneButton.setTitle("Done".localized(), for: .normal)
            
            var dateComponent = DateComponents()
            dateComponent.year = -18
            dateComponent.day = -1
            
            let maximunDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            datePicker!.picker.datePicker.maximumDate = maximunDate!
            datePicker!.picker.datePicker.setDate(maximunDate!, animated: true)
            datePicker!.picker.date = maximunDate!
        }
        
        //        datePicker!.picker.date = NSDate() as Date
        datePicker!.present(self)
    }

}
