//
//  EmailVerificationViewController.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 21/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol EmailVerificationViewControllerOutput: class {
    
    func presentLoginVC()
    func didResendVerifierEmail(with emailString: String?)
}

protocol EmailVerificationViewControllerInput: class {
    
    func showAlertError(with title: String?, message: String?)
    func emailHideSpinner()
}




class EmailVerificationViewController: VerifierAppDefaultViewController {
    
    var presenter:  EmailVerificationViewControllerOutput!
    
    var isErrorEmailVerification = false
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var emailImageView: UIImageView!
    
    var emailSting = String()
    
    
    // MARK: UIViewController Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        EmailVerificationAssembly.sharedInstance.configure(self)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isErrorEmailVerification {
            
            
            let heightConstraint = NSLayoutConstraint(item: firstLabel!, attribute: .height, relatedBy: .equal,
                                                   toItem: nil, attribute: .notAnAttribute,
                                                   multiplier: 1, constant: 14.0)
            
            view.addConstraint(heightConstraint)
            
           
            firstLabel.text = "Ваш email не подтвержден."
            
            twoLabel.text = "Для продолжения работы продтвердите свой email перейдя по ссылке в сообщении."
            threeLabel.text = "Если вы не получали письма, воспользуйтесь кнопкой:"
            threeLabel.alpha = 1
            repeatButton.alpha = 1
            repeatButton.isUserInteractionEnabled = true
            repeatButton.backgroundColor = UIColor.verifierDarkBlueColor()
            repeatButton.layer.cornerRadius = 4
            buttonLabel.alpha = 1
            emailImageView.alpha = 1
            
        } else {
            let heightConstraint = NSLayoutConstraint(item: firstLabel!, attribute: .height, relatedBy: .equal,
                                                      toItem: nil, attribute: .notAnAttribute,
                                                      multiplier: 1, constant: 46.0)
            
            view.addConstraint(heightConstraint)
            
            firstLabel.text = "На указанный вами эл. адрес отправленно сообщение."
            twoLabel.text = "Для продолжения работы подтвердите свой email, перейдя по ссылке в сообщении."
            threeLabel.text = "Если вы не получали письма, воспользуйтесь кнопкой:"
            threeLabel.alpha = 0
            repeatButton.alpha = 0
            repeatButton.isUserInteractionEnabled = false
            buttonLabel.alpha = 0
            emailImageView.alpha = 0
        }
        
        
        
        
        nextButton.backgroundColor = UIColor.verifierDarkBlueColor()
        nextButton.setTitle("Next".localized(), for: .normal)
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        presenter.presentLoginVC()
    }
    
    @IBAction func didPressRepeatButton(_ sender: Any) {
        print("Click button \(emailSting)")
        presenter.didResendVerifierEmail(with: self.emailSting)
        
    }
}
//MARK: ViewControllerInput
extension EmailVerificationViewController:  EmailVerificationViewControllerInput {
 
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func emailHideSpinner() {
        hideSpinner()
    }
    

}
