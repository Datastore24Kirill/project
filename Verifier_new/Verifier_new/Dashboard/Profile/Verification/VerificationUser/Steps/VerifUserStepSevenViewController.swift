//
//  VerifUserStepSevenViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 15/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import MobileCoreServices

class VerifUserStepSevenViewController: VerifierAppDefaultViewController, VerifUserStepModelDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberStudentLabel: UITextField!
    @IBOutlet weak var studentPhotoLabel: UILabel!
    @IBOutlet weak var studentPhotoImageView: verifierUIImageView!
    @IBOutlet weak var studentPhotoButton: verifierUIButton!
    @IBOutlet weak var certificateLabel: UITextField!
    @IBOutlet weak var certificatePhotoLabel: UILabel!
    @IBOutlet weak var certificatePhotoImageView: verifierUIImageView!
    @IBOutlet weak var certificatePhotoButton: verifierUIButton!
    
    
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
    
    @IBAction func studentPhotoButtonAction(_ sender: Any) {
        openDialogCamera(fieldId: 0)
        
    }
    
    @IBAction func certificatePhotoButtonAction(_ sender: Any) {
        openDialogCamera(fieldId: 1)
        
    }
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let numberStudent = numberStudentLabel.text, numberStudent != "",
            studentPhotoImageView.fieldLink != nil,
            let certificate = certificateLabel.text, certificate != "",
            certificatePhotoImageView.fieldLink != nil else {
            showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
            return
        }

        var documents = Singleton.shared.userVerificationData["userDocumentList"] as! [[String:Any]]

        var student = [String : Any]()
        if let index = documents.firstIndex(where: {$0["documentType"] as! String == "STUD"}) {
           
            documents[index]["documentType"] = "STUD"
            documents[index]["documentNumber"] = numberStudent
            documents[index]["studyForm"] = "очная"
            documents[index]["photoName"] = studentPhotoImageView.fieldLink
        
        } else {
            student["documentType"] = "STUD"
            student["documentNumber"] = numberStudent
            student["studyForm"] = "очная"
            student["photoName"] = studentPhotoImageView.fieldLink
            documents.append(student)
        }
        
        var certificateArr = [String : Any]()
        if let index = documents.firstIndex(where: {$0["documentType"] as! String == "CERTIFICATE"}) {
            
            documents[index]["documentType"] = "CERTIFICATE"
            documents[index]["documentNumber"] = certificate
            documents[index]["photoName"] = certificatePhotoImageView.fieldLink
            
        } else {
            certificateArr["documentType"] = "CERTIFICATE"
            certificateArr["documentNumber"] = certificate
            certificateArr["photoName"] = certificatePhotoImageView.fieldLink
            documents.append(certificateArr)
        }
    

    
        Singleton.shared.userVerificationData["userDocumentList"] = documents

    


        print("USER DATA \(Singleton.shared.userVerificationData)")
        
        model.verifierSetData(params: Singleton.shared.userVerificationData)
    }
    
    
    //MARK: - SUPPORT FUNC
    
    func setupImageView() {
        studentPhotoImageView.fieldId = 0
        certificatePhotoImageView.fieldId = 1
        
        studentPhotoImageView.layer.masksToBounds = true
        studentPhotoImageView.clipsToBounds = true
        studentPhotoImageView.contentMode = .scaleAspectFill
        
        certificatePhotoImageView.layer.masksToBounds = true
        certificatePhotoImageView.clipsToBounds = true
        certificatePhotoImageView.contentMode = .scaleAspectFill
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
            studentPhotoImageView.image = image
            studentPhotoButton.setTitleColor(UIColor.clear, for: .normal)
            studentPhotoImageView.fieldLink = link
        } else if fieldId == 1 {
            certificatePhotoImageView.image = image
            certificatePhotoButton.setTitleColor(UIColor.clear, for: .normal)
            certificatePhotoImageView.fieldLink = link
        }
        
        
    }
    
    func verifierSetDataSuccess() {
        
        let action = UIAlertAction(title: "ОК", style: .default) { (_) in
            
            self.navigationController?.popToRootViewController(animated: false)
            
        }
        self.showAlert(title: "", message: "Ваша заявка на верификацию успешно принята и отправлена на проверку", action: action)
        
    }
    
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
}

//MARK: - UIImagePickerControllerDelegate

extension VerifUserStepSevenViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
