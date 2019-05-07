//
//  RatingTaskViewController.swift.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import Cosmos

class RatingTaskViewController: UIViewController {
    
    @IBOutlet weak var cosmosStarRating: CosmosView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}





