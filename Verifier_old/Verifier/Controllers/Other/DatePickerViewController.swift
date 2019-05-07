//
//  DatePickerViewController.swift
//  Taddrees
//
//  Created by iPeople on 20.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

protocol DatePickerPickerProtocol {
    func didCancelDatePicker(datePickerViewController: UIViewController)
    func didChoseDate(datePickerViewController: UIViewController, date: Date, pickerType: DatePickerType)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerDarkView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var chooseItem: UILabel!
    
    var delegate: DatePickerPickerProtocol? = nil
    var pickerType: DatePickerType = .birthDay
    var selectedDate: Date = Date()
    var pickerMode: UIDatePickerMode = .date

    override func viewDidLoad() {
        super.viewDidLoad()

        self.applyLocalization()
        self.prepareDatePicker()
    }
    
    func applyLocalization() {
        
        chooseItem.text = "Choose a date".localized()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        doneButton.setTitle("Done".localized(), for: .normal)
    }
    
    func prepareDatePicker() {
        
        var date = Date()
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        self.datePicker.datePickerMode = pickerMode
        
        switch pickerType {
        case .birthDay:
            if let birthDate = User.sharedInstanse.birthDate  {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
                dateFormatter.dateFormat = "MMM d, yyyy"
                
                date = Date(timeIntervalSince1970: TimeInterval(birthDate))
                
            } else {
                let user = UserDefaultsVerifier.getUser()
                
                if let birthDate = user?.birthDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    
                    date = Date(timeIntervalSince1970: TimeInterval(birthDate))
                }
            }
            self.datePicker.minimumDate = minDate
            self.datePicker.maximumDate = Date()
        case .issue:
            if let issueDate = User.sharedInstanse.issueDate {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
                dateFormatter.dateFormat = "MMM d, yyyy"
                
                date = Date(timeIntervalSince1970: TimeInterval(issueDate))
            } else {
                let user = UserDefaultsVerifier.getUser()
                
                if let issueDate = user?.issueDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    
                    date = Date(timeIntervalSince1970: TimeInterval(issueDate))
                }
            }
            self.datePicker.minimumDate = minDate
            self.datePicker.maximumDate = Date()
        case .newOrderDateFrom:
            self.datePicker.datePickerMode = .dateAndTime
            self.datePicker.minimumDate = Date()
            date = selectedDate
            break
        case .newOrderDateTo:
            self.datePicker.datePickerMode = .dateAndTime
            self.datePicker.minimumDate = Date()
            date = selectedDate
            break
        case .newOrderTimeFrom:
            self.datePicker.datePickerMode = .time
            self.datePicker.minimumDate = Date()
            date = selectedDate
            break
        case .newOrderTimeTo:
            self.datePicker.datePickerMode = .time
            self.datePicker.minimumDate = Date()
            date = selectedDate
            break
        }
        
        self.datePicker.setDate(date, animated: true)
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        self.delegate?.didCancelDatePicker(datePickerViewController: self)
    }
    
    @IBAction func didPressDoneButton(_ sender: UIButton) {
        self.delegate?.didChoseDate(datePickerViewController: self, date: self.datePicker.date, pickerType: self.pickerType)
    }
}
