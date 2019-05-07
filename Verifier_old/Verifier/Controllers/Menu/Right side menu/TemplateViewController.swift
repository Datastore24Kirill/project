//
//  TemplateViewController.swift
//  Verifier
//
//  Created by Mac on 4/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class TemplateViewController: VerifierAppDefaultViewController {

    //MARK: - Outlets
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - Properties
    let menuHeaderVC = R.storyboard.menuHeader.menuHeaderVC()
    
    //MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareHeaderView()
    }
    
    //MARK: - Methods
    private func prepareHeaderView() {
        guard let controller = menuHeaderVC else { return }
        controller.titleHeader = "My Orders".localized()
        controller.preparePressMenuButton.delegate(to: self) { (self, _) in
            self.openMenu()
        }
        controller.view.frame = UIScreen.main.bounds
        controller.view.frame.size.height = 85
        view.addSubview(controller.view)
    }
}
