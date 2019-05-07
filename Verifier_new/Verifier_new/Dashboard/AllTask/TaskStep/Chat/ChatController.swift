//
//  ChatController.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 20/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit


class ChatViewController: VerifierAppDefaultViewController, JivoDelegate, ProfileViewControllerDelegate {
    
    

    var jivoSDK = JivoSdk()
    var langKey = String()
    var orderId: String?
    var isShowBackButton = false
    var orderName: String?
    var orderType: String?
    var profileModel = ProfileModel()
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    
    weak var viewController: ChatViewController!
    
    @IBOutlet weak var jivoWebView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    
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
        
        orderNameLabel.text = orderName != nil ? orderName! : "Чат службы поддержки"
        orderTypeLabel.text = orderType != nil ? orderType! : ""
        orderIdLabel.text = orderId != nil ? "№" + orderId! : ""
        
        profileModel.delegate = self
        profileModel.getVerifierUserInfo()
        
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        jivoSDK.stop()
    }
    
    func onEvent(_ name: String!, _ data: String!) {
        
        switch name {
            
        case "chat.ready":
            
                    if let firstName = firstName,
                        let lastName = lastName,
                        let email = email
                        {

                        let resultNumberTaskString = orderId != nil ? orderId! : ""

                            let info = ["client_name" : lastName, "email" : email, "phone" : phone, "description" :"\(firstName) \(lastName) TASKID: \(resultNumberTaskString)" ]
                        let jsonData = try! JSONSerialization.data(withJSONObject: info, options: [])
                        let decoded = String(data: jsonData, encoding: .utf8)
                        if let temp = decoded {
                            print("JSON \(temp)")
                            jivoSDK.callApiMethod("setContactInfo", temp)
                        }

                    }
            break
        case "agent.message":
            let systemSoundID: SystemSoundID = 1000
            AudioServicesPlaySystemSound (systemSoundID)
        default:
            break;
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
     self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [String: Any]) {
        
        let unchangeable = data["unchangeable"] as! [String: Any]
        let changeable = data["changeable"] as! [String: Any]
        
        firstName = (unchangeable["firstName"] as? String) ?? ""
        lastName = (unchangeable["lastName"] as? String) ?? ""
        email = (unchangeable["email"] as? String) ?? ""
        phone = (changeable["phone"] as? String) ?? ""
        
        jivoSDK.start()
        
    }
    
}


