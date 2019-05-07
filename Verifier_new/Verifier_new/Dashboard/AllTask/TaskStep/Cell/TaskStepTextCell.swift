//
//  TaskStepTextCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

protocol TaskStepTextCellDelegate: class {
//    func addToStepArray(fieldId: Int, fieldData: String, fieldRequired: Bool)
    func textViewChangeText(indexPath: IndexPath?, text: String, section: Int?)
}



class  TaskStepTextCell: UITableViewCell, UITextViewDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var descripotionLabel: UILabel!
    @IBOutlet weak var textView: verifierUITextView!
    @IBOutlet weak var requiredLabel: UILabel!
    
    //MARK: - DELEGATE
    weak var delegate: TaskStepTextCellDelegate?
    
    //MARK: - VARIABLES
    var indexPath:  IndexPath?
    var section:    Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor("#B0B0B5").cgColor
        textView.layer.borderWidth = 1
    
        if textView.text.isEmpty {
            textView.text = "TaskStep.TextViewPlaceHolder".localized()
            textView.textColor = UIColor.lightGray
        }
        else {
            textView.textColor = UIColor.black
        }
        
        textView.delegate = self
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            delegate?.textViewChangeText(indexPath: indexPath, text: textView.text, section: section)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {
            if textView.text == "TaskStep.TextViewPlaceHolder".localized() {
                textView.text = nil
            }
            textView.textColor = UIColor.black
        }

    }
//
    func textViewDidEndEditing(_ textView: UITextView) {

        let verifierUITextView = textView as! verifierUITextView
        if verifierUITextView.text.isEmpty {
            verifierUITextView.text = "TaskStep.TextViewPlaceHolder".localized()
            verifierUITextView.textColor = UIColor.lightGray
        }
//        if let textFieldsId = verifierUITextView.fieldId, var textViewText = textView.text ,
//            let fieldRequired = verifierUITextView.fieldRequired{
//            if textViewText == "TaskStep.TextViewPlaceHolder".localized() {
//                textViewText = ""
//            }
////            delegate?.addToStepArray(fieldId: textFieldsId, fieldData: textViewText, fieldRequired: fieldRequired)
//        }

    }
    
    func setupUI(stepField: StepField, indexPath: IndexPath?, section: Int?) {
        descripotionLabel.text  = (stepField.fieldName ?? "") + "\n\n" + (stepField.fieldDescription ?? "")
        textView.fieldRequired  = stepField.fieldRequired
        textView.text           = stepField.answerText
        requiredLabel.alpha     = stepField.fieldRequired ? 1 : 0
        if let IP = indexPath {
            self.indexPath = IP
            self.section = nil
        }
        else {
            self.indexPath = nil
            self.section = section
        }
    }
    
}
