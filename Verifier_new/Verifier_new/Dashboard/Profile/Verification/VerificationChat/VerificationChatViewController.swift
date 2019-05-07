//
//  VerificationChatViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 27/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import ReverseExtension

class VerificationChatViewController: VerifierAppDefaultViewController, VerificationChatViewControllerDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var verificationChatView: VerificationChatView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - PROPERTIES
    let model = VerificationChatModel()
    var chatDialogArray = [[String : Any]]()
    var isStop = false
    var indexPhraseArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.re.dataSource = self
        tableView.re.delegate = self
        tableView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        tableView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor("#F0F4F7")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        
        model.getDialog(branch: nil)
        model.delegate = self
    }
    
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
    }
    
    func loadDialog(array: [[String : Any]]){
        
        var time = 0
        for var value in array {
            time += 1
            
            print("value \(value)")
            print("TYT \(String(describing: value["index"])) indexPhrase \(self.indexPhraseArray)")
            if let index = value["index"] as? Int,
                self.indexPhraseArray.contains(index) == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
                    
                    self.chatDialogArray.append(value)
                    self.tableView.beginUpdates()
                    self.indexPhraseArray.append(index)
                    
                    self.tableView.re.insertRows(at: [IndexPath(row: self.chatDialogArray.count - 1, section: 0)], with: .automatic)
                    
                    self.tableView.endUpdates()
                    
                    
                }
            }
            
            
            
        }
    }

    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [[String: Any]]) {
        
        loadDialog(array: data)
    }
    
    
}



//MARK: UITableView
extension VerificationChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDialogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  self.cellUpdateDinamic(indexPath: indexPath, dictArray: self.chatDialogArray)
      
        return cell
        
    }
    

    
    //MARK: - SUPPORT METHOD
    
    func json(data: [[String : Any]]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
    
    func cellUpdateDinamic(indexPath: IndexPath, dictArray: [[String: Any]]) -> UITableViewCell {
        
        var dict =  dictArray[indexPath.row]
        
        
        let type = dict["type"] as? String
        
        
        switch type {
        case "applicationText":
            let chatCellWhite =  tableView.dequeueReusableCell(withIdentifier: "ChatBotСellWhite", for: indexPath) as! ChatBotCellWhite
            chatCellWhite.speechLabel.text = dict["value"] as? String
            

            
            
            return chatCellWhite
        case "question":
            let chatCellBlue =  tableView.dequeueReusableCell(withIdentifier: "ChatBotСellBlue", for: indexPath) as! ChatBotСellBlue
            chatCellBlue.speechLabel.text = dict["value"] as? String
           
          
            
            return chatCellBlue
        case "buttons":
            if let buttonType = dict["buttonType"] as? String, buttonType == "logicAnswer"{
                
                let buttonArray = dict["buttonValue"] as! [[String: Any]]
                let buttonOne = buttonArray[0]
                let buttonTwo = buttonArray[1]
                
                
                let chatCellLogical =  tableView.dequeueReusableCell(withIdentifier: "ChatUserButtonLogicalСell", for: indexPath) as! ChatUserButtonLogicalСell
                chatCellLogical.firstButton.setTitle(buttonOne["buttonTxt"] as? String, for: .normal)
                chatCellLogical.firstButton.addTargetClosure(){ _ in
                    print("first Button")
                    if let buttonAnswer = buttonOne["buttonAnswer"] as? String
                    {
                        print("count \(buttonAnswer)")
                        

                        self.model.getDialog(branch: buttonAnswer)
                      
                        
                    }
                    
                }
                
                chatCellLogical.lastButton.setTitle(buttonTwo["buttonTxt"] as? String, for: .normal)
                chatCellLogical.lastButton.addTargetClosure(){ _ in
                    print("last Button")
                    if let buttonAnswer = buttonTwo["buttonAnswer"] as? [String : Any]
                    {
                        print("buttonAnswer \(buttonAnswer)")
                       
                        self.loadDialog(array: [buttonAnswer])

                        
                        
                    }
                }
                
                
                
                return chatCellLogical
            } else if let buttonType = dict["buttonType"] as? String, buttonType == "answer"{
               
                var buttonAction = [String:Any]()
                if let buttonArray = dict["buttonValue"] as? [[String: Any]] {
                    buttonAction = buttonArray[0]
                } else if let buttonActionDict = dict["buttonValue"] as? [String: Any] {
                    buttonAction = buttonActionDict
                }
                
                
                let chatCellButton =  tableView.dequeueReusableCell(withIdentifier: "ChatUserButtonСell", for: indexPath) as! ChatUserButtonСell
                chatCellButton.actionButton.setTitle(buttonAction["buttonTxt"] as? String, for: .normal)
                chatCellButton.actionButton.addTargetClosure(){ _ in
                    print("OK")
                    if let continueArray = buttonAction["buttonContinue"] as? String {
                        self.model.getDialog(branch: continueArray)
                    }
                    
                }
                return chatCellButton
            }else if let buttonType = dict["buttonType"] as? String, buttonType == "show"{
                let buttonArray = dict["buttonValue"] as! [[String: Any]]
                let buttonAction = buttonArray[0]
                
                let chatCellButton =  tableView.dequeueReusableCell(withIdentifier: "ChatUserButtonСell", for: indexPath) as! ChatUserButtonСell
                chatCellButton.actionButton.setTitle(buttonAction["buttonTxt"] as? String, for: .normal)
                chatCellButton.actionButton.addTargetClosure(){ _ in
                    guard let url = URL(string: buttonAction["buttonLink"] as? String ?? "") else {
                        return //be safe
                    }
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                }
                return chatCellButton
            }
        case "branch":
            if let branch = dict["name"] as? String  {
                self.model.getDialog(branch: branch)
            }
            
        case "inputText":
            textViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
            
        default:
            break
        }
        
        
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor("#F0F4F7")
        
        
        return cell
        
    }
    
    
    private func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
   
    
    
}
