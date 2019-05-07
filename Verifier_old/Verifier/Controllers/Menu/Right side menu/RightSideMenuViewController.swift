//
//  RightSideMenuViewController.swift
//  Verifier
//
//  Created by Mac on 4/22/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class RightSideMenuViewController: VerifierAppDefaultViewController {
    
    //MARK: - Outlets
    
    //static labels
    @IBOutlet weak var menuStaticLabel: UILabel!
    @IBOutlet weak var personalAreaStaticLabel: UILabel!
    @IBOutlet weak var createNewOrderStaticLabel: UILabel!
    @IBOutlet weak var verifyOrderLabel: UILabel!
    @IBOutlet weak var myTasksStaticLabel: UILabel!
    @IBOutlet weak var taskOnVerificationStaticLabel: UILabel!
    @IBOutlet weak var filtersStaticLabel: UILabel!
    @IBOutlet weak var settingsStaticLabel: UILabel!
    @IBOutlet weak var walletStaticLabel: UILabel!
    
    @IBOutlet weak var jivoSiteStaticLabel: UILabel!
    //dynamic labels
    @IBOutlet weak var dollarsLabel: UILabel!
    @IBOutlet weak var vrfLabel: UILabel!
    
    //Constraints
    @IBOutlet weak var menuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var countTasksOnVerificationLabel: UILabel!
    @IBOutlet weak var countTasksOnVerificationView: GradientView!
    
    //Other
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    //Properties
    var delegate: DashboardNavigationViewControllerProtocol!
    var trayOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        prepareRightSwipe()
        prepareStaticText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showMenu()
    }
    
    //MARK: - Methods
    private func prepareData() {
        
        countTasksOnVerificationLabel.isHidden = true
        //countTasksOnVerificationLabel.text = "777"
        
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        if let monay = user.balance {
            vrfLabel.text = String(Int(monay * 10))
            dollarsLabel.text = String(Int(monay))
        } else {
            vrfLabel.text = "0"
            dollarsLabel.text = "0"
        }
        
    }
    
    private func prepareStaticText() {
        menuStaticLabel.text = "Menu".localized()
        personalAreaStaticLabel.text = "My Account".localized()
        //createNewOrderStaticLabel.text = "Create new order".localized()
        verifyOrderLabel.text = "In work".localized()
        //myTasksStaticLabel.text = "My Orders".localized()
        taskOnVerificationStaticLabel.text = "Orders to be verified".localized()
        settingsStaticLabel.text = "Settings".localized()
        walletStaticLabel.text = "Wallet".localized()
    }
    
    private func prepareRightSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture(gesture:)))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    private func showMenu() {
        menuTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.backgroundView.alpha = 0.4
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func labelAnimation(with label: UILabel) {
        label.alpha = 0
        UIView.animate(withDuration: 0.1, animations: {
            label.alpha = 1
            }
        )
    }
    
    private func hideMenu(completion: @escaping () -> ()) {
        menuTrailingConstraint.constant = UIScreen.main.bounds.width * 0.801205
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.backgroundView.alpha = 0.0
            self?.view.layoutIfNeeded()
            }, completion: { _ in
                completion()
        })
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        print("Tap gesture")
        if let swipeGesture = gesture as? UISwipeGestureRecognizer,
            swipeGesture.direction == UISwipeGestureRecognizerDirection.right {
            hideMenu { [weak self] in
                self?.dismiss(animated: false)
            }
        }
    }
    
    @objc func respondToTapGesture(gesture: UIGestureRecognizer)
    {
        if gesture is UITapGestureRecognizer {
            hideMenu { [weak self] in
                self?.dismiss(animated: false)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func didPressPrivateRoomButton(_ sender: UIButton) {
        labelAnimation(with: personalAreaStaticLabel)
        hideMenu { [weak self] in
            self?.delegate.openMenuItem(with: .personalArea)
        }
    }

    @IBAction func didPressVerifyOrderButton(_ sender: UIButton) {
        labelAnimation(with: verifyOrderLabel)
        hideMenu { [weak self] in
            self?.delegate.openMenuItem(with: .verifyOrder)
        }
    }

//    @IBAction func didPressCreateNewOrderButton(_ sender: UIButton) {
//        labelAnimation(with: myTasksStaticLabel)
//        hideMenu { [weak self] in
//            self?.delegate.openMenuItem(with: .createNewOrder)
//        }
//    }
    
//    @IBAction func didPressMyTasksButton(_ sender: UIButton) {
//        labelAnimation(with: myTasksStaticLabel)
//        hideMenu { [weak self] in
//            self?.delegate.openMenuItem(with: .myTasks)
//        }
//    }
    
    @IBAction func didPressTaskOnVerificationButton(_ sender: UIButton) {
        labelAnimation(with: taskOnVerificationStaticLabel)
        hideMenu { [weak self] in
            self?.delegate.openMenuItem(with: .taskOnVerification)
        }
    }
    
    @IBAction func didPressFiltersButton(_ sender: UIButton) {
        labelAnimation(with: filtersStaticLabel)
        hideMenu { [weak self] in
            self?.delegate.openMenuItem(with: .filters)
        }
    }
    
    @IBAction func didPressSettingsButton(_ sender: UIButton) {
        labelAnimation(with: settingsStaticLabel)
        hideMenu { [weak self] in
            self?.delegate.openMenuItem(with: .settings)
        }
    }
    
    @IBAction func OurTelegram(_ sender: Any) {
        
        let botURL = URL.init(string: "https://t.me/joinchat/AAAAAE-T_uSjxEjeVglHLw")
        
        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        }
        
    }
    
    @IBAction func didOpenJivoSite(_ sender: Any) {
        labelAnimation(with: jivoSiteStaticLabel)
        hideMenu { [weak self] in
            self?.delegate.openMenuItem(with: .jivosite)
            
        }
    }
    
}
