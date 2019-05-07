//
//  ProfileEditView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 20/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class ProfileEditView: UIView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var profileAvatarViewOut: UIView!
    @IBOutlet weak var profilePhotoLoad: UIImageView!
    @IBOutlet weak var profileAvatarViewIn: UIView!
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    
    
    
    func localizationView() {
        
        profileAvatarViewIn.layer.cornerRadius = profileAvatarImageView.frame.size.width/2
        profileAvatarViewIn.clipsToBounds = true
        profileAvatarViewIn.layer.borderColor = UIColor.white.cgColor
        profileAvatarViewIn.layer.borderWidth = 5
        
        screenTitle.text = "ProfileEdit.ScreenTitle".localized()
        nickNameTextField.placeholder = "SignUp.NickName".localized()
        firstNameTextField.placeholder = "ProfileEdit.FirstName".localized()
        lastNameTextField.placeholder = "ProfileEdit.LastName".localized()
        birthdayTextField.placeholder = "Registration.StepTwo.Birthday".localized()
        phoneTextField.placeholder = "ProfileEdit.Phone".localized()
        emailTextField.placeholder = "Email".localized()
        editButton.setTitle("Save".localized(), for: .normal)
    
    }
}
