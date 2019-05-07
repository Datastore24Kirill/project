//
//  PopUpWindowViewController.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol PopUpWindowProtocol {
    func didPressFacebookButton()
    func didPressTwitterButton()
    func didPressOKButton()
    func didPressHidePopUpButton()
}

class PopUpWindowViewController: UIViewController {
    
    @IBOutlet weak var showSocialViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideSocialViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var vrfLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextView!
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var popUpVIew: UIView!
    
    var delegate: PopUpWindowProtocol? = nil
    var showSocialView: Bool = false
    var rating = 0
    var vrf = 0.0
    
    override func viewDidLayoutSubviews() {
        okButton.setBlackGradient(view: okButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "\("TitlePopUp".localized())"
        //vrfLabel.text = "+\(vrf) \(NSLocalizedString("Currency", comment: ""))"
        //ratingLabel.text = "+\(rating) \(NSLocalizedString("To Vote", comment: ""))"
        
        
        if showSocialView {
            self.showSocialViewConstraint.priority = UILayoutPriority(rawValue: 999)
            self.hideSocialViewConstraint.priority = UILayoutPriority(rawValue: 333)
        } else {
            self.showSocialViewConstraint.priority = UILayoutPriority(rawValue: 333)
            self.hideSocialViewConstraint.priority = UILayoutPriority(rawValue: 999)
        }

        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationDarkView()
    }
    
    func animationDarkView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.darkView.alpha = 1
        }, completion: { _ in
            self.animationPopUpView()
        })
    }
    
    func animationPopUpView() {
        UIView.animate(withDuration: 0.15, animations: {
            self.popUpVIew.alpha = 1
            self.okButton.alpha = 1
            self.okButton.setBlackGradient(view: self.okButton)
        }, completion: nil)
    }
    
    //MARK: Action
    @IBAction func didPressHidePopUpWindowButton(_ sender: UIButton) {
        self.delegate?.didPressHidePopUpButton()
    }
    
    @IBAction func didPressTwiiterButton(_ sender: UIButton) {
        self.delegate?.didPressTwitterButton()
    }
    
    @IBAction func didPressFacebookButton(_ sender: UIButton) {
        self.delegate?.didPressFacebookButton()
    }
    
    @IBAction func didPressOkButton(_ sender: UIButton) {
        
        showSocialView = true
        
        if showSocialView {
            self.delegate?.didPressOKButton()
        } else {
            showSocialView = true
            
            self.showSocialViewConstraint.priority = UILayoutPriority(rawValue: 999)
            self.hideSocialViewConstraint.priority = UILayoutPriority(rawValue: 333)
            
            self.view.layoutIfNeeded()
        }
    }
}
