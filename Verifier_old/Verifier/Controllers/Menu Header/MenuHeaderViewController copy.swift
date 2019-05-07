//
//  MenuHeaderViewController.swift
//  Verifier
//
//  Created by Mac on 4/30/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class MenuHeaderViewController: VerifierAppDefaultViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    var preparePressMenuButton = DelegetedManager<()>()
    var titleHeader = "VERIFIER"
    var descriptionHeader = ""
    //MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleHeader
        descriptionLabel.text = descriptionHeader
    }

    //MARK: - Actions
    @IBAction func didPressMenuButton(_ sender: UIButton) {
        preparePressMenuButton.callback?(())
    }
}
