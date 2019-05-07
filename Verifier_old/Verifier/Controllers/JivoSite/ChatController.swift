//
//  ChatController.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 20/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import AVFoundation


class ChatViewController: VerifierAppDefaultViewController, JivoDelegate {
    
    

    var jivoSDK = JivoSdk()
    var langKey = String()
    var numberOfTask = String()
    var isShowBackButton = false
    
    weak var viewController: ChatViewController!
    
    @IBOutlet weak var jivoWebView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    // MARK: - lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        langKey = "ru"
        jivoSDK = JivoSdk(jivoWebView, langKey)
        jivoSDK.delegate = self
        jivoSDK.prepare()
        if !isShowBackButton {
            backButton.isHidden = true
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subTitleLabel.text = "Чат службы поддержки"
        jivoSDK.start()
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        jivoSDK.stop()
    }
    
    func onEvent(_ name: String!, _ data: String!) {
        
        switch name {
            
        case "chat.ready":
                    guard let user = UserDefaultsVerifier.getUser() else { return }
                    if let firstName = user.firstName,
                        let lastName = user.lastName,
                        let email = user.email {
                        
                        let resultNumberTaskString = numberOfTask.count > 0 ? "TaskID: \(numberOfTask)" : ""
                        
                        let info = ["client_name" : firstName, "email" : email,"phone" : "", "description" :"\(firstName) \(lastName) \(resultNumberTaskString)" ]
                        let jsonData = try! JSONSerialization.data(withJSONObject: info, options: [])
                        let decoded = String(data: jsonData, encoding: .utf8)
                        if let temp = decoded {
                            print("JSON \(temp)")
                            jivoSDK.callApiMethod("setContactInfo", temp)
                        }
                       
                    }
        case "agent.message":
            let systemSoundID: SystemSoundID = 1000
            AudioServicesPlaySystemSound (systemSoundID)
        default:
            break;
        }
    }
    
    @IBAction func didPressMenuButton(_ sender: Any) {
        
        openMenu()
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        
//        self.viewController.navigationController?.popViewController(animated: true)
//

        
        navigationController?.popViewController(animated: true)
        
    }
    
}


