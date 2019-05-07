//
//  IntroViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 05/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

class IntroViewController: VerifierAppDefaultViewController {
    
   
    //MARK: - OUTLETS
    @IBOutlet var introView: IntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        introView.localizationView()
        RealmSwiftAction.updateRealm(verifierId: nil, enterToken: nil, pushToken: nil, isFirstLaunch: false)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //Setup Filter
    func setupFilterDefault(){
       RealmSwiftFilterAction.resetToDefault()
    }
    //ButtonAction
    @IBAction func enterButtonAction(_ sender: Any) {
        print("enter")
        let storyboard = InternalHelper.StoryboardType.signIn.getStoryboard()
        let indentifier = ViewControllers.signInVC.rawValue
        setupFilterDefault()
        if let signInVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignInViewController {
            signInVC.didShowBackButton = true
            
            self.navigationController?.pushViewController(signInVC, animated: true)
            
        }
        
    }
    
    @IBAction func registrationButtonAction(_ sender: Any) {
        let storyboard = InternalHelper.StoryboardType.signUp.getStoryboard()
        let indentifier = ViewControllers.signUpvC.rawValue
        
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? SignUpViewController {
           setupFilterDefault()
            self.navigationController?.pushViewController(signUpVC, animated: true)
            
        }
    }
    
}
