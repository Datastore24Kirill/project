//
//  PickerViewViewController.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 14.01.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol PickerDataProtocol {
    func didCancelPickerData()
    func didChosePickerItem(value: String, typeField: PickerViewViewController.TypeField)
}

class PickerViewViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerDarkView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var chooseItem: UILabel!
    
    var delegate: PickerDataProtocol? = nil
    var type = TypeField.nationality
    
    enum TypeField {
        case addressType, nationality
    }
    
    var pickerDataArray: [String] = ["USA", "RUS"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyLocalization()
        self.preparePickerView()
    }
    
    func applyLocalization() {
        
        switch type {
        case .addressType:
            chooseItem.text = "Choose type address".localized()
        case .nationality:
            chooseItem.text = "Choose the country".localized()
        }
        
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        doneButton.setTitle("Done".localized(), for: .normal)
    }
    
    func preparePickerView() {
        switch type {
        case .nationality:
            
            if let passportType = User.sharedInstanse.passportType  {
                
                for i in 0..<pickerDataArray.count {
                    if pickerDataArray[i] == passportType {
                        pickerView.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
            } else {
                
                let user = UserDefaultsVerifier.getUser()
                
                guard let passportType = user?.passportType else { return }
                
                for i in 0..<pickerDataArray.count {
                    if pickerDataArray[i] == passportType {
                        pickerView.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
            }
            
        case .addressType:
            
            if let addressType = User.sharedInstanse.address?.addressType  {
                
                for i in 0..<pickerDataArray.count {
                    if pickerDataArray[i] == addressType {
                        pickerView.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
                
            } else {
                
                let user = UserDefaultsVerifier.getUser()
                
                guard let addressType = user?.address?.addressType else { return }
                
                for i in 0..<pickerDataArray.count {
                    if pickerDataArray[i] == addressType {
                        pickerView.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
            }
            
        }
    }

    // MARK: - Navigation
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        self.delegate?.didCancelPickerData()
    }
    
    @IBAction func didPressDoneButton(_ sender: UIButton) {
        self.delegate?.didChosePickerItem(value: self.pickerDataArray[self.pickerView.selectedRow(inComponent: 0)], typeField: type)
    }

}

extension PickerViewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataArray[row]
    }
}









