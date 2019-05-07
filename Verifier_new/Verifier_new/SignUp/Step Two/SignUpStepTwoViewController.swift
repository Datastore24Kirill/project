//
//  SignUpStepTwoViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 07/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import UDatePicker

class SignUpStepTwoViewController: VerifierAppDefaultViewController, SignUpStepTwoModelDelegate, SignUpStepTwoViewDelegate {
    
    //MARK: - PROPERTIES
    var model = SignUpStepTwoModel()
    var paramsStepOne = [String:String]()
    var datePicker: UDatePicker?
    var allParamsToSend = [String:String]()
    
    @IBOutlet var signUpStepTwoView: SignUpStepTwoView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signUpStepTwoView.delegate = self
        signUpStepTwoView.localizationView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
        print("paramsStepOne Params -> \(paramsStepOne)")
    }
    
    //MARK: - ACTION
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
   
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func showDatePicker(){
       
        if datePicker == nil  {
           
            datePicker = UDatePicker(frame: signUpStepTwoView.frame, willDisappear: { date in
                if self.datePicker!.picker.doneButton.isTouchInside {
                    if let resultDate = date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd.MM.YYYY"
                        let birthdayDateString = formatter.string(from: resultDate) // string purpose I add here
                        self.signUpStepTwoView.birthdayTimeStamp = String(Int64((resultDate.timeIntervalSince1970).rounded()))
                        self.signUpStepTwoView.birthdayTextView.text = birthdayDateString;
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
    
    //MARK: - REGISTRATION
    
    func registration(params: [String:String]) {
        allParamsToSend = params.merging(paramsStepOne, uniquingKeysWith: { (first, _) in first })
        print("ALLPARAMS \(allParamsToSend)")
        showSpinner()
        self.model.didRegisterVerifier(parametrs: allParamsToSend)
    }
    
    func didShowStepFinal() {
        self.view.endEditing(true)
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.stepFinalVC.rawValue
        
        if let stepFinalVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? StepFinalViewController {
            stepFinalVC.params = allParamsToSend
            self.navigationController?.pushViewController(stepFinalVC, animated: true)
            
        }
    }
}

