//
//  PromoViewController.swift
//  Verifier
//
//  Created by Кирилл on 14/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import YouTubePlayer

protocol PromoViewControllerOutput: class {
    
    func presentDashboardVC()
}

class PromoViewController: VerifierAppDefaultViewController, YouTubePlayerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var youTubePlayer: YouTubePlayerView!
    @IBOutlet weak var nextButton: UIButton!
    
    var presenter: PromoViewControllerOutput!

    // MARK: UIViewController Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PromoAssembly.sharedInstance.configure(self)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youTubePlayer.delegate = self
        nextButton.backgroundColor = UIColor.verifierDarkBlueColor()
        showSpinner()
        UserDefaultsVerifier.setIsPromoViewed(with: "true")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        youTubePlayer.playerVars = [
            "playsinline": "1",
            "controls": "0",
            "showinfo": "0"
            ] as YouTubePlayerView.YouTubePlayerParameters
        
        
        youTubePlayer.loadVideoID("lwoGZxDxjjk")
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        print("PLAYER READY")
        hideSpinner()
        youTubePlayer.play()
    }
    

    
   
    

    @IBAction func nextButtonAction(_ sender: Any) {
        presenter.presentDashboardVC()
    }
}

