//
//  AlertErrorViewController.swift
//  Verifier
//
//  Created by Mac on 21.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//
import UIKit

protocol AlertErrorProtocol {
    func didPressOKButton()
}

class AlertErrorViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: Properties
    var delegate: AlertErrorProtocol? = nil
    var currentTitle = ""
    var currentDescription = ""
    
    override func viewDidLayoutSubviews() {
        okButton.setBlackGradient(view: okButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = currentTitle
        descriptionLabel.text = currentDescription
    }
    
    //MARK: Actions
    @IBAction func didPressOkButton(_ sender: UIButton) {
        delegate?.didPressOKButton()
    }
    
}
