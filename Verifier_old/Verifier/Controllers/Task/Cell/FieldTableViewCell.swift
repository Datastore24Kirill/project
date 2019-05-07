//
//  FieldTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 06.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    var parentVC: BaseDetailTaskViewController? = nil
    
    func updateContentData(filed: Field) {
        
        dataTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.dataTextField.placeholder = "Fill this field...".localized()
        self.infoLabel.text = filed.label
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        self.parentVC?.textFieldResignFirstResponder(textField: textField)
    }
}

//MARK: UITextFieldDelegate
extension FieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.parentVC?.textFieldResignFirstResponder(textField: textField)
        textField.resignFirstResponder()
        return true
    }
}
