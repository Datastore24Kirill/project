//
//  VerifUserStepTwoViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 14/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import PopupDialog
import UDatePicker

class VerifUserStepTwoViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passportSeriesLabel: UITextField!
    @IBOutlet weak var documentNumberLabel: UITextField!
    @IBOutlet weak var issueLabel: UITextField!
    @IBOutlet weak var issueCodeLabel: UITextField!
    @IBOutlet weak var issueDateLabel: UITextField!
    
    
    //MARK: - PROPERTIES
    var datePicker: UDatePicker?
    var issueDateTimeStamp: String?

    
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
    
    @IBAction func issueDateButtonAction(_ sender: Any) {
        showDatePicker()
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let passportSeries = passportSeriesLabel.text, passportSeries != "",
            let documentNumber = documentNumberLabel.text, documentNumber != "",
            let issue = issueLabel.text, issue != "",
            let issueCode = issueCodeLabel.text, issueCode != "",
            let issueDate = issueDateLabel.text, issueDate != "" else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }


        var documents = [[String:Any]]()
        
        var passport = [String : Any]()
        passport["documentType"] = "PASS"
        passport["passportType"] = "РФ"
        passport["passportSeries"] = passportSeries
        passport["documentNumber"] = documentNumber
        passport["issue"] = issue
        passport["issueDate"] = issueDateTimeStamp
        passport["issueCode"] = issueCode
        
        documents.append(passport)
        
        Singleton.shared.userVerificationData["userDocumentList"] = documents
        

        print("USER DATA \(Singleton.shared.userVerificationData)")
        
        let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
        let indentifier = ViewControllers.verificationUserStepThreeVC.rawValue
        
        if let verificationUserStepThreeVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepThreeViewController {
            self.navigationController?.pushViewController(verificationUserStepThreeVC, animated: true)
            
        }
        
        
        
    }
    
    
    
    //MARK: - SUPPORT FUNC
    
    func showStepOnePopup(animated: Bool = true) {
        
        // Create a custom view controller
        
        
        // Create the dialog
        let popup = PopupDialog(title: "Теперь возьмите свой паспорт", message: "У вас паспорт РФ?", image: nil)
        
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
                        let issueDateString = formatter.string(from: resultDate) // string purpose I add here
                        self.issueDateTimeStamp = String(Int64((resultDate.timeIntervalSince1970).rounded()))
                        self.issueDateLabel.text = issueDateString;
                    }
                }
                
            })
            datePicker!.picker.doneButton.setTitle("Done".localized(), for: .normal)
            
            datePicker!.picker.datePicker.maximumDate = Date()
            datePicker!.picker.datePicker.setDate(Date(), animated: true)
            datePicker!.picker.date = Date()
        }
        
        //        datePicker!.picker.date = NSDate() as Date
        datePicker!.present(self)
    }
    
    
    
}

