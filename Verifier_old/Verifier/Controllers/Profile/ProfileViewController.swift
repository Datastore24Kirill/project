//
//  ProfileViewController.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit
import Cosmos
import GoogleMaps
import GooglePlaces

protocol ProfileProtocol: class {
    func didOpenDatePickerView(type: DatePickerType)
    func didOpenPickerView(values: [String], typeField: PickerViewViewController.TypeField)
}

protocol ProfileViewControllerOutput: class {
    func didEditProfile()
    func didTapVerify(verifAddr: String, long: Double, lat: Double, timeTo: Int) 
}

protocol ProfileViewControllerInput: class {
    func hideProfileViewSpinner()
    func showProfileViewAlert(with: String, message: String)
    func provideResponseResult(with result: ResponseResult)
}

class ProfileViewController: VerifierAppDefaultViewController {
    
    //MARK: Outlet
    @IBOutlet private weak var profileCollectionView: UICollectionView!
    @IBOutlet private weak var buttonsScrollView: UIScrollView!
    
    //userInfo
    @IBOutlet private weak var profileLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userIDLabel: UILabel!
    @IBOutlet private weak var userPhotoImageView: UIImageView!
    @IBOutlet private weak var amountStarsLabel: UILabel!
    @IBOutlet private weak var starsView: CosmosView!
    @IBOutlet private var collectionElementButtons: [UIButton]!
    @IBOutlet private weak var menuContentView: UIView!
    @IBOutlet private weak var markerButtonLabel: UIView!
    
    
    //MARK: - properties
    
    var presenter: ProfileViewControllerOutput!
    private var currentIndexDirectionCollection = 0
    
    private var datePickerVC: DatePickerViewController = DatePickerViewController()
    private var pickerVC: PickerViewViewController = PickerViewViewController()
    private var pickerImage = UIImagePickerController()
    
    private var didEndScrollingAnimation = true
    private var saveVerify: (String, Double, Double, Int)?
    
    private let identifiers = [
        CellIdentifiers.Indentifiers.personalCell.rawValue,
        CellIdentifiers.Indentifiers.idDataCell.rawValue,
        CellIdentifiers.Indentifiers.addressCell.rawValue,
        CellIdentifiers.Indentifiers.emailCell.rawValue,
//        CellIdentifiers.Indentifiers.verifyCell.rawValue
        
    ]
    
    private func getCellIdentifiers() -> [String: Any] {
        
        let identifiersUiNib = [
            CellIdentifiersUINibs.Indentifiers.personalCell.rawValue,
            CellIdentifiersUINibs.Indentifiers.idDataCell.rawValue,
            CellIdentifiersUINibs.Indentifiers.addressCell.rawValue,
            CellIdentifiersUINibs.Indentifiers.emailCell.rawValue,
//            CellIdentifiersUINibs.Indentifiers.verifyCell.rawValue
        ]
        
        var dict = [String: Any]()
        
        for i in 0..<identifiers.count {
            dict.updateValue(UINib(nibName: identifiersUiNib[i], bundle: nil), forKey: identifiers[i])
        }
        
        return dict
    }
    
    enum ViewControllers: String {
        case alertErrorVC = "AlertErrorVC"
        case signInVC = "SignInVC"
        case signUpVC = "SignUpVC"
        case datePickerVC = "DatePickerVC"
        case pickerViewVC = "PickerVC"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: UIViewController Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserParameters()
        setButtonsLocalization()
        getCellIdentifiers().forEach {
            self.profileCollectionView.register($0.value as? UINib, forCellWithReuseIdentifier: $0.key)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMark()
    }
    
    
    //MARK: - private
    
    private func setupMark() {
        DispatchQueue.main.async {
            let frame = self.collectionElementButtons[0].frame
            let newFrame = CGRect(x: frame.minX, y: 58, width: frame.width, height: 4)
            self.markerButtonLabel.frame = newFrame
        }
    }
    
    private func setUserParameters() {
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        if let photo = user.photo {
            userPhotoImageView.downloadedFrom(link: photo)
            userPhotoImageView.layer.masksToBounds = false
            userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width/2
            userPhotoImageView.clipsToBounds = true
        }
        
        if let name = user.firstName {
            userNameLabel.text = name
            if let lastName = user.lastName {
                userNameLabel.text = "\(name) \(lastName)"
            }
        }
    }
    
    private func setButtonsLocalization() {
        profileLabel.text = "Profile".localized()
        collectionElementButtons[0].setTitle("Personal data".localized(), for: .normal)
        collectionElementButtons[1].setTitle("ID data".localized(), for: .normal)
        collectionElementButtons[2].setTitle("Address".localized(), for: .normal)
        collectionElementButtons[3].setTitle("Email".localized(), for: .normal)
//        collectionElementButtons[4].setTitle("Verify".localized(), for: .normal)
    }
    
    private func didMoveCollectionElementVC(with index: Int) {
        if currentIndexDirectionCollection != index {
            currentIndexDirectionCollection = index
            paintActiveButton(with: index)
            moveMarkerForButton(with: index)
            let width = profileCollectionView.frame.size.width
            profileCollectionView.setContentOffset(CGPoint(x: width * CGFloat(index), y: 0), animated: true)
        }
    }
    
    private func didMoveScrollWithButtons(with index: Int) {
        let scrollPoint = getCGPointForScroll(with: index) ?? CGPoint(x: 0, y: 0)
        buttonsScrollView!.setContentOffset(scrollPoint, animated: true)
    }
    
    private func getCGPointForScroll(with index: Int) -> CGPoint? {
        let centerOffsetX = collectionElementButtons[index].frame.minX -  (buttonsScrollView.frame.width / 2)
        let leftX = centerOffsetX > 0 ? centerOffsetX : 0
        let maxOffset = menuContentView.frame.width - buttonsScrollView.frame.width
        let x = leftX > maxOffset ? maxOffset : leftX
        return CGPoint(x: x, y: 0)
    }
    
    private func paintActiveButton(with index: Int) {
        let colorNotActive = UIColor.white.withAlphaComponent(0.5)
        
        for i in 0..<collectionElementButtons.count {
            if i == index {
                collectionElementButtons[i].setTitleColor(.white, for: .normal)
            } else {
                collectionElementButtons[i].setTitleColor(colorNotActive, for: .normal)
            }
        }
    }
    
    private func moveMarkerForButton(with index: Int) {
        let buttonFrame = collectionElementButtons[index].frame
        let height: CGFloat = 4.0
        
        UIView.animate(withDuration: 0.25, animations: {
            let newFrame = CGRect(x: buttonFrame.minX, y: buttonFrame.maxY - height, width: buttonFrame.width, height: height)
            self.markerButtonLabel.frame = newFrame
        })
    }
    
    private func didShootPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerImage.allowsEditing = false
            pickerImage.sourceType = UIImagePickerControllerSourceType.camera
            pickerImage.cameraDevice = .front
            pickerImage.cameraCaptureMode = .photo
            pickerImage.modalPresentationStyle = .fullScreen
            present(pickerImage,animated: true,completion: nil)
        }
    }
    
    private func clearUser() {
        UserDefaultsVerifier.deleteEmailAndPassword()
        profileCollectionView.reloadItems(at: [IndexPath(item: 3, section: 0)] )
        
        User.sharedInstanse = User()
    }
    
    
    // MARK: - actions
    
    @IBAction func didPressBackButton(_ sender: UIButton) {
        clearUser()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didPressMenuButton(_ sender: UIButton) {
        openMenu()
    }
    
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        showSpinner()
        presenter.didEditProfile()
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        
        pickerImage.delegate = self
        let actionSheetController = UIAlertController(title: nil, message: "Uploading photo".localized(), preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel".localized(), style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let takeActionButton = UIAlertAction(title: "Take a Photo".localized(), style: .default) { action -> Void in
            self.didShootPhoto()
        }
        
        actionSheetController.addAction(takeActionButton)
        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.permittedArrowDirections = .up
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
        }
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func didPressCollectionElementButton(_ sender: UIButton) {
        didMoveCollectionElementVC(with: sender.tag)
        didMoveScrollWithButtons(with: sender.tag)
        didEndScrollingAnimation = false
    }
}


//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return identifiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifiers[indexPath.row], for: indexPath) as! DefaultProfileCollectionViewCell
        cell.delegate = self
        cell.reload()
        
//        if let verifyCell = cell as? VerifyCollectionViewCell {
//            verifyCell.didPressAddressButton.delegate(to: self) { (self, _) in
//                let acController = GMSAutocompleteViewController()
//                acController.delegate = verifyCell.googleMapManager
//                self.present(acController, animated: true, completion: nil)
//            }
//            verifyCell.didPressDatePickerButton.delegate(to: self) { (self, _) in
//                guard let controller = R.storyboard.other.datePickerVC() else {
//                    return
//                }
//                controller.delegate = verifyCell
//                controller.selectedDate = Date()
//                controller.pickerType = .newOrderTimeFrom
//                controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                self.present(controller, animated: false)
//            }
//            verifyCell.didPressSaveButton.delegate(to: self) { (self, arg1) in
//                self.showSpinner()
//                self.saveVerify = arg1
//                self.presenter.didEditProfile()
//            }
//            verifyCell.showAlertHandler.delegate(to: self) { (self, alert) in
//                self.showAlert(title: alert.title, message: alert.message)
//            }
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == profileCollectionView && didEndScrollingAnimation {
            let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
            
            if pageNumber != currentIndexDirectionCollection {
                currentIndexDirectionCollection = pageNumber
                paintActiveButton(with: pageNumber)
                moveMarkerForButton(with: pageNumber)
                didMoveScrollWithButtons(with: pageNumber)
            }
        }
    }
}


//MARK: ProfileProtocol
extension ProfileViewController: ProfileProtocol {
    
    func didOpenPickerView(values: [String], typeField: PickerViewViewController.TypeField) {
        self.view.endEditing(true)
        
        self.pickerVC = InternalHelper.StoryboardType.other.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.pickerViewVC.rawValue) as! PickerViewViewController
        
        self.pickerVC.delegate = self
        self.pickerVC.pickerDataArray = values
        self.pickerVC.type = typeField
        self.pickerVC.view.frame = UIScreen.main.bounds
        self.view.addSubview(self.pickerVC.view)
    }
    
    func didOpenDatePickerView(type: DatePickerType) {
        self.view.endEditing(true)
        
        self.datePickerVC = InternalHelper.StoryboardType.other.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.datePickerVC.rawValue) as! DatePickerViewController
        
        self.datePickerVC.delegate = self
        self.datePickerVC.pickerType = type
        self.datePickerVC.view.frame = UIScreen.main.bounds
        
        self.view.addSubview(self.datePickerVC.view)
    }
}


//MARK: DatePickerPickerProtocol, PickerDataProtocol

extension ProfileViewController: DatePickerPickerProtocol, PickerDataProtocol {
    
    func didCancelPickerData() {
        self.pickerVC.view.removeFromSuperview()
    }
    
    func didChosePickerItem(value: String, typeField: PickerViewViewController.TypeField) {
        self.pickerVC.view.removeFromSuperview()
        
        switch typeField {
        case .addressType:
            if User.sharedInstanse.address == nil {
                User.sharedInstanse.address = User.Address()
            }
            
            let cell = profileCollectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! AddressProfileCollectionViewCell
            
            cell.addressTypeTextField.text = value
            
            User.sharedInstanse.address?.addressType = value
            
        case .nationality:
            let cell = profileCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! PersonalProfileCollectionViewCell
            cell.nationalityTextField.text = value
            
            User.sharedInstanse.passportType = value
        }
    }
    
    func didCancelDatePicker(datePickerViewController: UIViewController) {
        self.datePickerVC.view.removeFromSuperview()
    }
    
    func didChoseDate(datePickerViewController: UIViewController, date: Date, pickerType: DatePickerType) {
        self.datePickerVC.view.removeFromSuperview()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let dateStr = dateFormatter.string(from: date)
        
        switch pickerType {
            
        case .birthDay:
            let cell = profileCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! PersonalProfileCollectionViewCell
            cell.birthDateTextField.text = dateStr
            
            User.sharedInstanse.birthDate = Int64((date.timeIntervalSince1970).rounded())
            
        case .issue:
            let cell = profileCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! IdDataCollectionViewCell
            cell.issueDateTextFiled.text = dateStr
            
            User.sharedInstanse.issueDate = Int64((date.timeIntervalSince1970).rounded())
        default:
            break
        }
    }
}


//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            User.sharedInstanse.profilePhoto = UIImageJPEGRepresentation(chosenImage, 1.0)
            userPhotoImageView.image = chosenImage
        }
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}


//MARK: ViewControllerInput

extension ProfileViewController: ProfileViewControllerInput {
    
    func hideProfileViewSpinner() {
        hideSpinner()
    }
    
    func showProfileViewAlert(with: String, message: String) {
        showAlert(title: with, message: message)
    }
    
    func provideResponseResult(with result: ResponseResult) {
        hideSpinner()
        switch result {
        case .success:
            if let verify = saveVerify {
                let (verifAddr, long, lat, timeTo) = verify
                saveVerify = nil
                self.showSpinner()
                self.presenter.didTapVerify(verifAddr: verifAddr, long: long, lat: lat, timeTo: timeTo)
                return
            }
            
            if let value = User.sharedInstanse.photo {
                userPhotoImageView.downloadedFrom(link: value)
            }
            UserDefaultsVerifier.setNameAndLastName()
            
            if let user = UserDefaultsVerifier.getUser() {
                if let firstName = user.firstName {
                    userNameLabel.text = firstName
                    if let lastName = user.lastName {
                        userNameLabel.text = "\(firstName) \(lastName)"
                    }
                }
            }
            clearUser()
            let message = "Success change personal info".localized()
            showAlert(title: "", message: message)
        case .failed(let message):
            if User.sharedInstanse.password != nil || User.sharedInstanse.repeatPassword != nil {
                profileCollectionView.reloadItems(at: [IndexPath(item: 3, section: 0)] )
            }
            
            let title = "InternetErrorTitle".localized()
            showAlert(title: title, message: message)
        case .noInternet:
            let title = "InternetErrorTitle".localized()
            let message = "InternetErrorMessage".localized()
            showAlert(title: title, message: message)
        case .serverError(_):
                let title = "InternetErrorTitle".localized()
                let message = "Server error".localized()
                showAlert(title: title, message: message)
        default: break
        }
    }
}

