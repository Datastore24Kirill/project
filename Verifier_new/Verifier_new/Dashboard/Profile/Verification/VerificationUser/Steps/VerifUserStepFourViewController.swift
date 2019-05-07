//
//  VerifUserStepFourViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 15/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//


import Foundation
import PopupDialog
import UDatePicker

class VerifUserStepFourViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressRegionLabel: UITextField!
    @IBOutlet weak var addressCityLabel: UITextField!
    @IBOutlet weak var addressStreetLabel: UITextField!
    @IBOutlet weak var addressHouseLabel: UITextField!
    
    @IBOutlet weak var addressFlatLabel: UITextField!
    @IBOutlet weak var addressZipCodeLabel: UITextField!
    
    
    
    //MARK: - PROPERTIES

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localizationView()

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func localizationView() {
        screenTitle.text = "Verification.ScreenTitle".localized()
        nextButton.setTitle("Next".localized(), for: .normal)
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let addressRegion = addressRegionLabel.text, addressRegion != "",
            let addressCity = addressCityLabel.text, addressCity != "",
            let addressStreet = addressStreetLabel.text, addressStreet != "",
            let addressHouse = addressHouseLabel.text, addressHouse != "",
            let addressFlat = addressFlatLabel.text, addressFlat != "",
            let addressZipCode = addressZipCodeLabel.text, addressZipCode != "" else {
                showAlert(title: "Error".localized(), message: "Error.AllFieldsAreRequired".localized())
                return
        }


        var addressesArr = [[String:Any]]()

        var addresses = [String : Any]()
        addresses["addressType"] = "reg"
        addresses["addressCountry"] = "Россия"
        addresses["addressRegion"] = addressRegion
        addresses["addressCity"] = addressCity
        addresses["addressStreet"] = addressStreet
        addresses["addressHouse"] = addressHouse
        addresses["addressFlat"] = addressFlat
        addresses["addressZipCode"] = addressZipCode

        addressesArr.append(addresses)

        Singleton.shared.userVerificationData["userAddressList"] = addressesArr


        print("USER DATA \(Singleton.shared.userVerificationData)")

        let storyboard = InternalHelper.StoryboardType.verificationUser.getStoryboard()
        let indentifier = ViewControllers.verificationUserStepFiveVC.rawValue

        if let verificationUserStepFiveVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerifUserStepFiveViewController {
            self.navigationController?.pushViewController(verificationUserStepFiveVC, animated: true)
        }
        
        
    }
    
    
    
   
    
    
    
}

