//
//  VerifierPickerViewController.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 28.04.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol VerifierPickerProtocol {
    func closePicker(picker: UIViewController)
    func selectValue(in array: [String], for index: Int, picker: UIViewController)
}

class VerifierPickerViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerDarkView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var chooseItem: UILabel!
    
    // MARK: - Properties
    var pickerDataArray: [String] = []
    var selectedValue: String = ""
    
    var delegate: VerifierPickerProtocol? = nil

    // MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        prepareData()
    }

    func prepareUI() {
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        doneButton.setTitle("Done".localized(), for: .normal)
        chooseItem.text = "Choose item".localized()
    }
    
    func prepareData() {
        for (index, item) in pickerDataArray.enumerated() {
            if (item == selectedValue) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    // MARK: - Navigation
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.closePicker(picker: self)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.selectValue(in: pickerDataArray, for: pickerView.selectedRow(inComponent: 0), picker: self)
    }

}

extension VerifierPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
