//
//  PublicProfileFTViewController.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit
import CoreLocation

protocol LoginViewControllerOutput: class {
    func didRegistration(with user: User)
    func didOpenDashboardVC()
    func didOpenImagePickerVC()
    func didLoginFB()
    func didLoginTwitter()
}

protocol LoginViewControllerInput: class {
    func provideResponseResult(with result: ResponseResult)
    func didEnabelNextButton(status: Bool)
    func didOpenDatePickerView(type: DatePickerType)
    func didOpenImagePickerView()
    func didOPenPickerView(values: [String], typeField: PickerViewViewController.TypeField)
    func didRegistrWithTwitterFacebook()
}

class LoginViewController: VerifierAppDefaultViewController {

    //MARK: Outlet
    @IBOutlet weak var containerViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var okButton: ShadowButton!
    @IBOutlet weak var moreWebButton: ShadowButton!

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var showHeaderLogoViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideHeaderLogoViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var showHeaderButtonsViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideHeaderButtonsViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInButtonInActiveHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButtonActiveHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signUpButtonInActiveHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonActiveHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerLogoView: UIView!
    @IBOutlet weak var headerButtonsView: UIView!
    
    enum ViewControllers: String {
        case alertErrorVC = "AlertErrorVC"
        case signInVC = "SignInVC"
        case signUpVC = "SignUpVC"
        case datePickerVC = "DatePickerVC"
        case pickerViewVC = "PickerVC"
    }
    
    //MARK: Properties
    var childVC: UIViewController!
    var presenter: LoginViewControllerOutput!
    var alertErrorVC = AlertErrorViewController()
    var datePickerVC: DatePickerViewController = DatePickerViewController()
    var pickerVC: PickerViewViewController = PickerViewViewController()
    let locationManager = CLLocationManager()
    
    // MARK: UIViewController Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        LoginAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInButton.setTitle("Login".localized(), for: .normal)
        self.signUpButton.setTitle("Registration".localized(), for: .normal)
        containerHeightViewConstraint.constant = 220
        moreWebButton.setTitle("MORE OF THE WEBSITE".localized(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.okButton.setBlackGradient(view: self.okButton)
        self.setLoginButtonDesign(tag: 0)
        didPressSignInButton(self.signInButton)
        
        locationManager.requestWhenInUseAuthorization()

        hideKeyboardWhenTappedAround()

        //locationManager.requestAlwaysAuthorization()
        //locationManager.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moreWebButton.setBlackGradient(view: moreWebButton)
    }
    
    func didLoadVC(vc: UIViewController, and rect: CGRect) {
        
        self.containerView.subviews.forEach({ $0.removeFromSuperview() })
        self.childViewControllers.forEach({ $0.removeFromParentViewController() })
        
        self.addChildViewController(vc)
        vc.view.frame = rect
        self.containerView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    //MARK: Methods
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
    }
    
    func openUrl() {
        guard let url = URL(string: "http://web.verifier.org/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func setLoginButtonDesign(tag: Int) {
        if tag == 0 {
            self.signInButton.setTitleColor(UIColor.white, for: .normal)
            self.signUpButton.setTitleColor(UIColor.black, for: .normal)
            
            self.signInButton.backgroundColor = UIColor.verifierLoginButtonActiveColor()
            self.signUpButton.backgroundColor = UIColor.verifierLoginButtonInActiveColor()
            
            self.signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            self.signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            
            self.signInButtonActiveHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            self.signInButtonInActiveHeightConstraint.priority = UILayoutPriority(rawValue: 333)
            
            self.signUpButtonActiveHeightConstraint.priority = UILayoutPriority(rawValue: 333)
            self.signUpButtonInActiveHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            
            self.signInButton.layer.cornerRadius = 25
            self.signUpButton.layer.cornerRadius = 15
            
        } else {
            
            self.signUpButton.setTitleColor(UIColor.white, for: .normal)
            self.signInButton.setTitleColor(UIColor.black, for: .normal)
            
            self.signUpButton.backgroundColor = UIColor.verifierLoginButtonActiveColor()
            self.signInButton.backgroundColor = UIColor.verifierLoginButtonInActiveColor()
            
            self.signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            self.signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            
            self.signInButtonActiveHeightConstraint.priority = UILayoutPriority(rawValue: 333)
            self.signInButtonInActiveHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            
            self.signUpButtonActiveHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            self.signUpButtonInActiveHeightConstraint.priority = UILayoutPriority(rawValue: 333)
            
            self.signInButton.layer.cornerRadius = 15
            self.signUpButton.layer.cornerRadius = 25
        }
        
        self.view.layoutIfNeeded()
    }

    func showPromocodeAlert() {
        let alert = UIAlertController(title: "If you have promo code, please enter".localized(), message: "Please enter 8 symbols".localized(), preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: "OK".localized(), style: .default) {[weak self] (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text?.count == 0 {

                let okAction = UIAlertAction(title: "OK".localized(), style: .default) { (alertAction) in

                    User.sharedInstanse.promocode = textField.text!

                    self?.showSpinner()
                    self?.presenter.didRegistration(with: User.sharedInstanse)
                }

                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .default) { (alertAction) in
                    self?.showPromocodeAlert()
                }

                let alert = UIAlertController(title: "Promo is empty. Do you want to continue?".localized(), message: "", preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(cancelAction)
                alert.addAction(okAction)

                self?.present(alert, animated:true, completion: nil)

            } else if textField.text?.count != 8 {

                let action = UIAlertAction(title: "OK".localized(), style: .default) { (alertAction) in
                    self?.showPromocodeAlert()
                }

                self?.showAlert(title: "Promo isn't correct".localized(), message: "", action: action)

                self?.didEnabelNextButton(status: true)
            } else {

                User.sharedInstanse.promocode = textField.text!

                self?.showSpinner()
                self?.presenter.didRegistration(with: User.sharedInstanse)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (alertAction) in
            self.didEnabelNextButton(status: true)
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Enter your promo code".localized()
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        self.present(alert, animated:true, completion: nil)
    }
    
    //MARK: Action
    @IBAction func didPressFacebookButton(_ sender: UIButton) {
        presenter.didLoginFB()
    }
    
    @IBAction func didPressTwitterButton(_ sender: UIButton) {
        presenter.didLoginTwitter()
    }
    
    @IBAction func didPressSignInButton(_ sender: UIButton) {
        
        self.containerView.alpha = 0
        self.containerHeightViewConstraint.constant = 160
        UIView.animate(withDuration: 0.2) {
            self.containerView.alpha = 1
             self.view.layoutIfNeeded()
        }
        
        self.setLoginButtonDesign(tag: sender.tag)
        
        let signIn = InternalHelper.StoryboardType.login.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.signInVC.rawValue) as! SignInViewController
        
        signIn.parentVC = self
        childVC = signIn
        
        self.didLoadVC(vc: childVC, and: CGRect(x: self.containerView.bounds.origin.x, y: self.containerView.bounds.origin.y, width: self.containerView.bounds.size.width, height: self.containerView.bounds.size.height - 20))
        
        self.didEnabelNextButton(status: true)
    }
    
    @IBAction func didPressSignUpButton(_ sender: UIButton) {
        
        self.containerView.alpha = 0
        containerHeightViewConstraint.constant = 220
        UIView.animate(withDuration: 0.2) {
            self.containerView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        self.setLoginButtonDesign(tag: sender.tag)
        
        let signUp = InternalHelper.StoryboardType.login.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.signUpVC.rawValue) as! SignUpViewController
        
        signUp.parentVC = self
        childVC = signUp
        
        self.didLoadVC(vc: childVC, and: CGRect(x: self.containerView.bounds.origin.x, y: self.containerView.bounds.origin.y, width: self.containerView.bounds.size.width, height: self.containerView.bounds.size.height))
        
        self.didEnabelNextButton(status: false)
    }
    
    @IBAction func didPressOkButton(_ sender: UIButton) {
        
        if let signInVC = childVC as? SignInViewController {
            showSpinner()
            signInVC.login()
        } else if let signUpVC = childVC as? SignUpViewController {

            if let step = User.sharedInstanse.registrationStep {
                switch step {
                case 1:
                    self.showPromocodeAlert()
                case 2:
                    signUpVC.didOpenNextStepVC()
                case 3:
                    signUpVC.didOpenNextStepVC()
                case 4:
                    signUpVC.didOpenNextStepVC()
                case 5:
                    signUpVC.didOpenNextStepVC()
                case 6:
                    if let signUp = childVC as? SignUpViewController {
                        self.showSpinner()
                        signUp.registration()
                    }
                default: break
                }
            }

            self.didEnabelNextButton(status: false)
        }
    }
    
    @IBAction func didPressMoreWebButton(_ sender: UIButton) {
        self.view.endEditing(true)
        openUrl()
    }
}

//MARK: LoginViewControllerInput
extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if touch.view is UIButton { return false }
        else { return true }
    }
}

extension LoginViewController: LoginViewControllerInput {
    
    func provideResponseResult(with result: ResponseResult) {
        self.hideSpinner()
        switch result {
        case .success:
            self.view.endEditing(true)
            self.hideSpinner()
            presenter.didOpenDashboardVC()
        case .failed, .serverError:
            showAlert(title: "LoginErrorTitle".localized(), message: "LoginErrorDescription".localized())
        case .noInternet:
            let title = "InternetErrorTitle".localized()
            let message = "InternetErrorMessage".localized()
            showAlert(title: title, message: message)
        default: break
        }
    }
    
    func didEnabelNextButton(status: Bool) {
        
        self.okButton.setBlackGradient(view: self.okButton, isEnable: status)
        self.okButton.isEnabled = status ? true : false
        
        self.okButton.layoutSubviews()
    }
    
    func didOPenPickerView (values: [String], typeField: PickerViewViewController.TypeField) {
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
    
    func didOpenImagePickerView() {
        self.presenter.didOpenImagePickerVC()
    }

    func didRegistrWithTwitterFacebook() {
        self.showPromocodeAlert()
    }
}

extension LoginViewController: DatePickerPickerProtocol, PickerDataProtocol {
    
    func didCancelPickerData() {
        self.pickerVC.view.removeFromSuperview()
    }
    
    func didChosePickerItem(value: String, typeField: PickerViewViewController.TypeField) {
        
        self.pickerVC.view.removeFromSuperview()
        
        guard let signUp = childVC as? SignUpViewController else {
            return
        }
        
        switch typeField {
            
        case .addressType:
            
            let cell = signUp.signUpCollectionView.cellForItem(at: IndexPath(item: 4, section: 0)) as! AddressCollectionViewCell
            cell.addressTypeTextField.text = value
            cell.registrationTextFieldAction(cell.addressTypeTextField)
            
            User.sharedInstanse.address?.addressType = value
            
        case .nationality:
            
            let cell = signUp.signUpCollectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! PassportCollectionViewCell
            cell.nationalityTextField.text = value
            cell.registrationTextFieldsAction(cell.nationalityTextField)
            
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
            
            if let signUp = childVC as? SignUpViewController {
                let cell = signUp.signUpCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! UserInfoCollectionViewCell
                cell.birthDateTextField.text = dateStr
                cell.validateTextFields(textField: cell.birthDateTextField)
            }
            
            User.sharedInstanse.birthDate = Int64((date.timeIntervalSince1970).rounded())
        case .issue:
            
            if let signUp = childVC as? SignUpViewController {
                let cell = signUp.signUpCollectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as! IssueCollectionViewCell
                cell.issueDateTextFiled.text = dateStr
                cell.validateTextFields(textField: cell.issueDateTextFiled)
            }
            
            User.sharedInstanse.issueDate = Int64((date.timeIntervalSince1970).rounded())
            
        default:
            break
        }
    }
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            User.sharedInstanse.profilePhoto = UIImageJPEGRepresentation(chosenImage, 1.0)
            
            if let signUp = childVC as? SignUpViewController {
                let cell = signUp.signUpCollectionView.cellForItem(at: IndexPath(item: 5, section: 0)) as! UserPhotoCollectionViewCell
                cell.validateUserPhoto(profileImage: chosenImage)
            }
        }
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}

