//
//  SettingsProfileViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit


class SettingsProfileViewController: VerifierAppDefaultViewController, SettingsProfileViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - OUTLETS
    @IBOutlet var settingsProfileView: SettingsProfileView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - PROPERTIES
    var settingsLabel = [String]()
    var verificationStatus: Int?
    
    let cellReuseIdentifier = "SettingsСell"
    let model = SettingsProfileModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsProfileView.localizationView()
        settingsLabel = ["Profile.Settings.EditProfile".localized(),
                            "Profile.Settings.ChangePassword".localized(),
                            "Profile.Settings.VerProfile".localized(),
                            "Profile.Settings.ChangeLanguage".localized(),
                            "Profile.Settings.Documents".localized()]
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOAD")
        model.delegate = self
        
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
         self.navigationController?.hidesBottomBarWhenPushed = false
         self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.showSpinner()
        model.logout()
    }
    
    
    //MARK UITableViewDELEGATE
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsLabel.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SettingsProfileTableCell
        // set the text from the data model
        
        print("\(settingsLabel[indexPath.row])")
        
        if indexPath.row == 2 {
            switch verificationStatus {
            
            case 1:
                //На проверке
                 cell.settingsLabel?.text = ""
                 cell.isHidden = true
                 
                return UITableViewCell()
            case 2:
                //Верифицирован
                cell.settingsLabel?.text = ""
                cell.isHidden = true
                return UITableViewCell()
            default:
                cell.settingsLabel?.text = settingsLabel[indexPath.row]
            }
        } else {
            cell.settingsLabel?.text = settingsLabel[indexPath.row]
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44
        if indexPath.row == 2 {
            switch verificationStatus {
                
            case 1:
                height =  0
            case 2:
                height =  0
                
            default:
                return height
            }
        }
        return height
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.profileEditVC.rawValue
            
            if let profileEditVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? ProfileEditViewController {
                self.navigationController?.pushViewController(profileEditVC, animated: true)
                
            }
        case 1:
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.changePasswordVC.rawValue
            
            if let changePasswordVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? ChangePasswordViewController {
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
                
            }
        case 2:
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.verificationVC.rawValue
            
            if let verificationVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? VerificationViewController {
                self.navigationController?.pushViewController(verificationVC, animated: true)
                
            }
        case 3:
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.changeLanguageVC.rawValue
            
            if let changeLanguageVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? ChangeLanguageViewController {
                self.navigationController?.pushViewController(changeLanguageVC, animated: true)
                
            }
        case 4:
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.documentsVC.rawValue
            
            if let documentsVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DocumentsViewController {
                self.navigationController?.pushViewController(documentsVC, animated: true)
                
            }
        default:
            break
        }
        
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    

}

class SettingsProfileTableCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var settingsLabel: UILabel!
    
    
}
