//
//  FeedBackView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class FeedBackView: UIView, UITextViewDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    func localizationView() {
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.borderWidth = 0.5
        messageTextView.layer.cornerRadius = 5
        
        screenTitle.text = "SupportMail".localized()
        sendButton.setTitle("Send".localized(), for: .normal)
        nameTextField.placeholder = "FeedBack.Name".localized()
        emailTextField.placeholder = "Email".localized()
        messageTextView.text = "FeedBack.Message".localized()
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "FeedBack.Message".localized()
            textView.textColor = UIColor.lightGray
        }
    }
    
}
