//
//  SettingsViewController.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 23.04.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SettingsViewControllerOutput: class {
    func showShareActivity(with text: String)
    func showPicker(for items: [String], selectedValue: String)
    
    func getUserSettings()
    func setUserWallet(with address: String)
    func sendFeedBack(with subject: String, and text: String)
}

protocol SettingsViewControllerInput: class {
    func provideData(with result: ServerResponse<UserSettings>)
    func provideWalletAddressSettingData(result: ResponseResult)
    func provideFeedBackSendingData(result: ResponseResult)
}

class SettingsViewController: VerifierAppDefaultViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var rusButton: UIButton!
    @IBOutlet weak var engButton: UIButton!
    
    
    @IBOutlet weak var promocodeLabel: UILabel!
    
    @IBOutlet weak var promocodeValueLabel: SRCopyableLabel!
    @IBOutlet weak var promocodeShareTextLabel: UILabel!
    
    @IBOutlet weak var appShareLabel: UILabel!
    @IBOutlet weak var appShareTextLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectValueLabel: UILabel!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var feedbackButtonButton: UIButton!
    
    //MARK: - Properties
    var presenter: SettingsViewControllerOutput!
    
    var subjects: [String] = []
    
    var settings: UserSettings?
    
    enum Language {
        case rus
        case eng
    }
    
    var selectedSubject: String = ""
    
    //MARK: - UIViewController methods
    override func awakeFromNib() {
        super.awakeFromNib()
        SettingsAssembly.sharedInstance.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        changeLanguageButtonsUI()
        prepareData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Data
    func prepareData() {
        showSpinner()

        guard let user = UserDefaultsVerifier.getUser() else { return }
        
//        if let monay = user.balance {
//            balanceValueLabel.text = String(Int(monay * 10))
//        } else {
//            balanceValueLabel.text = "0"
//        }
        
        presenter.getUserSettings()
    }

    func getSubjects() {
        subjects = ["Subject 1".localized(), "Subject 2".localized(), "Subject 3".localized(), "Subject 5".localized()]

        subjectValueLabel.text = subjects[0]
        selectedSubject = subjects[0]
    }
    
    //MARK: - UI
    func prepareUI() {
        navTitleLabel.text = "Settings nav".localized()
        languageLabel.text = "Select the language".localized()
        
//        walletAddressLabel.text = "Address of Etherium wallet".localized()
//        walletAddressTextField.placeholder = "Enter the address".localized()
//        walletAddressSaveButton.setTitle("Save".localized(), for: .normal)
//        walletAddressSaveButton.layer.cornerRadius = 5.0
//        walletAddressSaveButton.setBlackGradient(view: walletAddressSaveButton)
//
//        balanceButton.setTitle("Withdraw money".localized(), for: .normal)
//        balanceButton.layer.cornerRadius = 5.0
//        balanceButton.setBlackGradient(view: balanceButton)
//        balanceLabel.text = "Balance".localized()
//        balanceView.layer.cornerRadius = 5.0
        
//        promocodeValueLabel.clipsToBounds = true
//        promocodeValueLabel.layer.cornerRadius = 5.0
//        promocodeLabel.text = "Your promocode".localized()
//        promocodeShareTextLabel.text = "Share your promocode with your friend to get bonus tokens".localized()
        
        appShareLabel.text = "Share the application".localized()
        appShareTextLabel.text = "If you liked the application, please, share it with your friends with a reference link.".localized()
        
        feedbackButtonButton.backgroundColor = UIColor.verifierBlueColor()
        feedbackButtonButton.layer.cornerRadius = 5.0
        feedbackButtonButton.setTitle("Save".localized(), for: .normal)
        feedbackLabel.text = "Feedback".localized()
        subjectLabel.text = "Subject of your message".localized()

        rusButton.setTitle("Русский", for: .normal)
        rusButton.layer.borderWidth = 1.0
        rusButton.layer.cornerRadius = 5.0
        rusButton.layer.borderColor = UIColor.verifierBlueColor().cgColor

        engButton.setTitle("English", for: .normal)
        engButton.layer.borderWidth = 1.0
        engButton.layer.cornerRadius = 5.0
        engButton.layer.borderColor = UIColor.verifierBlueColor().cgColor
    }
    
    func changeLanguageButtonsUI() {
        if InternalHelper.sharedInstance.getCurrentLanguage() == "ru" {
            rusButton.setTitleColor(UIColor.white, for: .normal)
            engButton.setTitleColor(UIColor.verifierBlueColor(), for: .normal)
            rusButton.backgroundColor = UIColor.verifierBlueColor()
            engButton.backgroundColor = UIColor.clear
        } else {
        rusButton.setTitleColor(UIColor.verifierBlueColor(), for: .normal)
            engButton.setTitleColor(UIColor.white, for: .normal)
            engButton.backgroundColor = UIColor.verifierBlueColor()
            rusButton.backgroundColor = UIColor.clear
        }

        prepareUI()
        getSubjects()
    }
    
    //MARK: - Actions
    @IBAction func rusButtonTapped(_ sender: Any) {
        UserDefaults.standard.setValue("ru", forKey: "lang")
        changeLanguageButtonsUI()
    }
    
    @IBAction func engButtonTapped(_ sender: Any) {
        UserDefaults.standard.setValue("en", forKey: "lang")
        changeLanguageButtonsUI()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        openMenu()
    }
    
    @IBAction func walletAddressButtonTapped(_ sender: UIButton) {
        showSpinner()
//        presenter.setUserWallet(with: walletAddressTextField.text!)
    }
    
    @IBAction func balanceButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func appStoreButtonTapped(_ sender: UIButton) {
        guard let settings = settings else {
            return
        }
        presenter.showShareActivity(with: settings.downloadLinkApple)
    }
    
    @IBAction func feedBackButtonTapped(_ sender: UIButton) {
        showSpinner()
        presenter.sendFeedBack(with: selectedSubject, and: feedbackTextView.text)
    }
    
    @IBAction func subjectsButtonTapped(_ sender: UIButton) {
        presenter.showPicker(for: subjects, selectedValue: selectedSubject)
    }
    
}

extension SettingsViewController: SettingsViewControllerInput {
    func provideData(with result: ServerResponse<UserSettings>) {
        switch result {
        case .success(let settings):
            self.settings = settings
            
//            promocodeValueLabel.text = settings.promoCode
//            walletAddressTextField.text = settings.blockChainWallet
        default:
            break
        }
        
        hideSpinner()
    }
    
    func provideWalletAddressSettingData(result: ResponseResult) {
        hideSpinner()
    }
    
    func provideFeedBackSendingData(result: ResponseResult) {
        print("res == \(result)")
        showAlert(title: "", message: "Thank you for your feedback".localized())
        hideSpinner()
    }
}

extension SettingsViewController: VerifierPickerProtocol {
    func closePicker(picker: UIViewController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    func selectValue(in array: [String], for index: Int, picker: UIViewController) {
        picker.dismiss(animated: false) { [weak self] in
            self?.selectedSubject = array[index]
            self?.subjectValueLabel.text = self?.selectedSubject
        }
    }
}
