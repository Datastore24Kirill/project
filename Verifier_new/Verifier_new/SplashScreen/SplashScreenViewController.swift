//
//  SplashScreenViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import ImageSlideshow

class SplashScreenViewController: VerifierAppDefaultViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var splashScreenView: SplashScreenView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        imageSlideShow.setImageInputs([
            ImageSource(imageString: "Slide1")!,
            ImageSource(imageString: "Slide2")!,
            ImageSource(imageString: "Slide3")!,
            ImageSource(imageString: "Slide4")!,
            ImageSource(imageString: "Slide5")!,
            ImageSource(imageString: "Slide6")!
            ])
       
        imageSlideShow.circular = false
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        pageControl.numberOfPages =  imageSlideShow.images.count
        
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splashScreenView.localizationView()
    }
    
    
    //MARK: - ACTION
    @IBAction func nextButtonAction(_ sender: Any) {
        print("enter")
        let storyboard = InternalHelper.StoryboardType.splashScreen.getStoryboard()
        let indentifier = ViewControllers.introvC.rawValue
        
        if let signInVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? IntroViewController {
            
            self.navigationController?.pushViewController(signInVC, animated: true)
            
        }
    }
    

    

    
}
