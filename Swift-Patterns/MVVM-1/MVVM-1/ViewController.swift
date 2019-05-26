//
//  ViewController.swift
//  MVVM-1
//
//  Created by Кирилл Ковыршин on 13/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            self.nameLabel.text = viewModel.name
            self.secondNameLabel.text = viewModel.secondName
            self.ageLabel.text = viewModel.age
        }
    }
    
//    var profile: Profile? {
//        didSet {
//            guard let profile = profile else { return }
//            
//            self.nameLabel.text = profile.name
//            self.secondNameLabel.text = profile.secondName
//            self.ageLabel.text = String(profile.age)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
       
    }


}

