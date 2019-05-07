//
//  VerifUserStepFiveViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 15/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import MobileCoreServices

class VerifUserStepFiveViewController: VerifierAppDefaultViewController, VerifUserStepModelDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressImageView: verifierUIImageView!
    @IBOutlet weak var addressPhotoButton: verifierUIButton!
   
    
    
    
    //MARK: - PROPERTIES
    var model = VerifUserStepModel()
    var imagePicker = verifierUIImagePickerController()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localizationView()
        model.delegate = self
        setupImageView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addressPhotoButtonAction(_ sender: Any) {
        openDialogCamera(fieldId: 0)
        
    }
    

    
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard addressImageView.fieldLink != nil else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        var addresses = Singleton.shared.userVerificationData["userAddressList"] as? [[String:Any]]
        if let index = addresses?.firstIndex(where: {$0["addressType"] as! String == "reg"}) {
            
            addresses?[index]["photoName"] = addressImageView.fieldLink
            
            Singleton.shared.userVerificationData["userAddressList"] = addresses
        }
        
        print ("array \(Singleton.shared.userVerificationData)")
        
        
        let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
        let indentifier = ViewControllers.verificationUserStepSixVC.rawValue
        
        if let verificationUserStepSixVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepSixViewController {
            self.navigationController?.pushViewController(verificationUserStepSixVC, animated: true)
            
        }
        
    }
    
    
    //MARK: - SUPPORT FUNC
    
    func setupImageView() {
        addressImageView.fieldId = 0
        
        addressImageView.layer.masksToBounds = true
        addressImageView.clipsToBounds = true
        addressImageView.contentMode = .scaleAspectFill
        
        
    }
    
    func localizationView() {
        screenTitle.text = "Verification.ScreenTitle".localized()
        nextButton.setTitle("Next".localized(), for: .normal)
    }
    
    func openDialogCamera(fieldId: Int?) {
        
        let alert = UIAlertController(title: "GetPhoto".localized() , message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: { _ in
            self.openCamera(fieldId: fieldId)
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Open the camera
    func openCamera(fieldId: Int?){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.isPhoto = true
            
            if let _fieldId = fieldId {
                imagePicker.fieldId = _fieldId
            }
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Error".localized(), message: "Error.Camera".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - DELEGATE
    
    func updatePhoto(link: String, image: UIImage, fieldId: Int) {
        
        if fieldId == 0 {
            addressImageView.image = image
            addressPhotoButton.setTitleColor(UIColor.clear, for: .normal)
            addressImageView.fieldLink = link
        }
        
        
    }
    
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    
}


//MARK: - UIImagePickerControllerDelegate

extension VerifUserStepFiveViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        let pickerVer = picker as! verifierUIImagePickerController
        
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.showSpinner()
        print(selectedImage)
        if let fieldId = pickerVer.fieldId {
            model.uploadPhoto(image: selectedImage, fieldId: fieldId)
        }
        
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

