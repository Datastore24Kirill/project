//
//  VerifUserStepThreeViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 15/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import MobileCoreServices

class VerifUserStepThreeViewController: VerifierAppDefaultViewController, VerifUserStepModelDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoPassportLabel: UILabel!
    @IBOutlet weak var passportImageView: verifierUIImageView!
    @IBOutlet weak var passportPhotoButton: verifierUIButton!
    @IBOutlet weak var passportWithYouImageView: verifierUIImageView!
    @IBOutlet weak var passportPhotoWithYouButton: verifierUIButton!
    
    
    
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
    
    @IBAction func passportPhotoButtonAction(_ sender: Any) {
        openDialogCamera(fieldId: 0)
        
    }
    
    @IBAction func passportPhotoWithYouButtonAction(_ sender: Any) {
        openDialogCamera(fieldId: 1)
    }
    
    

    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard  passportImageView.fieldLink != nil,
                passportWithYouImageView.fieldLink != nil else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }
        
        
        var documents = Singleton.shared.userVerificationData["userDocumentList"] as? [[String:Any]]
        if let index = documents?.firstIndex(where: {$0["documentType"] as! String == "PASS"}),
            let firstPhoto = passportImageView.fieldLink,
            let twoPhoto = passportWithYouImageView.fieldLink {
           
            documents?[index]["photoName"] = firstPhoto + "," + twoPhoto
            Singleton.shared.userVerificationData["userDocumentList"] = documents
        }
        
        print ("array \(Singleton.shared.userVerificationData)")
        
//
        
        let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
        let indentifier = ViewControllers.verificationUserStepFourVC.rawValue

        if let verificationUserStepFourVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepFourViewController {
            self.navigationController?.pushViewController(verificationUserStepFourVC, animated: true)
        }
        
        
        
    }
    
    
    //MARK: - SUPPORT FUNC
    
    func setupImageView() {
        passportImageView.fieldId = 0
        passportWithYouImageView.fieldId = 1
        
        passportImageView.layer.masksToBounds = true
        passportImageView.clipsToBounds = true
        passportImageView.contentMode = .scaleAspectFill
        
        passportWithYouImageView.layer.masksToBounds = true
        passportWithYouImageView.clipsToBounds = true
        passportWithYouImageView.contentMode = .scaleAspectFill
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
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
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
            passportImageView.image = image
            passportPhotoButton.setTitleColor(UIColor.clear, for: .normal)
            passportImageView.fieldLink = link
        } else if fieldId == 1 {
            passportWithYouImageView.image = image
            passportPhotoWithYouButton.setTitleColor(UIColor.clear, for: .normal)
            passportWithYouImageView.fieldLink = link
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

extension VerifUserStepThreeViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
