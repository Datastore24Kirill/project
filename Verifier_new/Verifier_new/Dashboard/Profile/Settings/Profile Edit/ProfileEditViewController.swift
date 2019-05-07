//
//  ProfileEditViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 20/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import UDatePicker
import SDWebImage

class ProfileEditViewController: VerifierAppDefaultViewController, ProfileEditViewControllerDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var profileEditView: ProfileEditView!
    
    
    //MARK: - PROPERTIES
    var userInfo: [String: Any]?
    let model = ProfileEditModel()
    var datePicker: UDatePicker?
    var birthdayTimeStamp: String?
    var birthdayDate: Date?
    var imagePicker = UIImagePickerController()
    var photoLink: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileEditView.localizationView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let params = Singleton.shared.userInfo {
            updateTextFields(userInfo: params)
            userInfo = params
        }
        
        
        model.delegate = self
    }
    
    //MARK: - ACTIONS
    func updateTextFields(userInfo: [String: Any]) {
        print("USERINFO \(userInfo)")
        profileEditView.nickNameTextField.text = userInfo["nickname"] as? String
        profileEditView.firstNameTextField.text = userInfo["firstName"] as? String
        profileEditView.lastNameTextField.text = userInfo["lastName"] as? String
        profileEditView.phoneTextField.text = userInfo["phone"] as? String
        profileEditView.emailTextField.text = userInfo["email"] as? String
        
        if let birthday = userInfo["birthdate"] as? Int {
            let date = Date(timeIntervalSince1970: Double(birthday))
            birthdayDate = date
            let dateFormatter = DateFormatter()
            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
            print(localTimeZoneAbbreviation)
            dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd.MM.YYYY" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            profileEditView.birthdayTextField.text = strDate
        }
        
        
        let photoLink = (userInfo["photo"] as? String) ?? ""
        
        profileEditView.profileAvatarViewIn.layer.masksToBounds = false
        profileEditView.profileAvatarViewIn.clipsToBounds = true
        profileEditView.profileAvatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        profileEditView.profileAvatarImageView.sd_imageIndicator = SDWebImageProgressIndicator.default
        profileEditView.profileAvatarImageView.sd_setImage(with: URL(string: photoLink), placeholderImage: nil)
    }
    


    
    //MARK: - ACTIONS BUTTON
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        guard let nickname = profileEditView.nickNameTextField.text, nickname != "",
            let phone = profileEditView.phoneTextField.text, phone != ""
        else {
            showAlertError(with: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
            return
        }
        
        var params: [String: Any] = ["nickname": nickname, "phone": phone]
        if let link = photoLink {
            params["photo"] = link
        }
        
        model.updateVerifier(params: params)
    }
    
    @IBAction func changePhotoButtonAction(_ sender: Any) {
        print("change photo")
        
        
        let alert = UIAlertController(title: "ChooseImage".localized(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery".localized(), style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updatePhoto(link: String, image: UIImage) {
        profileEditView.profileAvatarImageView.image = image
        showAlertError(with: "ProfileEditOk.Title".localized(), message: "ProfileEditOk.ImageMsg".localized())
        photoLink = link
        
    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension ProfileEditViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.showSpinner()
        model.uploadAvatar(image: selectedImage)
        
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
