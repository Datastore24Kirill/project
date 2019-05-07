//
//  VerifierAppDefaultViewController.swift
//  Verifier
//
//  Created by Mac on 28.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD

class VerifierAppDefaultViewController: UIViewController {
    
    typealias MenuItem = DashboardNavigationViewController.Item
    
    func showSpinner() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideSpinner() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK".localized(), style: .default)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String, action: UIAlertAction) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openMenu() {
        
        guard let myNav = navigationController as? DashboardNavigationViewController else {
            return
        }
        
        myNav.openMenu()
    }
    
}
