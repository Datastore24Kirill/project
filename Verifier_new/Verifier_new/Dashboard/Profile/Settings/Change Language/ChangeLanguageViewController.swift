//
//  ChangeLanguageViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 13/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//


import UIKit


class ChangeLanguageViewController: VerifierAppDefaultViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - OUTLETS
    @IBOutlet var changeLanguageView: ChangeLanguageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - PROPERTIES
    let languageLabel: [[String:String]] = [["name":"Русский", "lang" : "ru"],
                                            ["name":"English", "lang" : "en"]]
    let cellReuseIdentifier = "LanguageСell"
    var currentLang = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeLanguageView.localizationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOAD")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        resetAllOrderLevel()
        
        currentLang = InternalHelper.sharedInstance.getCurrentLanguage()
        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK UITableViewDELEGATE
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languageLabel.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        
        let languageCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ChangeLanguageTableCell
        // set the text from the data model
        let dict = languageLabel[indexPath.row]
    
        
        languageCell.languageLabel?.text = dict["name"]
        if currentLang == dict["lang"] {
            languageCell.checkOnIcon.alpha = 1
            languageCell.backgroundColor = UIColor("#E8E8FF")
        }
        
        return languageCell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        resetAllOrderLevel()
        let languageCell = tableView.cellForRow(at: indexPath) as! ChangeLanguageTableCell
        
        languageCell.checkOnIcon.alpha = 1
        languageCell.backgroundColor = UIColor("#E8E8FF")
        
        let dict = languageLabel[indexPath.row]
        print("You tapped cell number \(indexPath.row). name \(String(describing: dict["name"]))")

        UserDefaults.standard.setValue(dict["lang"] ?? "ru", forKey: "lang")
        
        changeLanguageView.localizationView()
        
        locolizeTabBar()
        
    }
    
    
    func resetAllOrderLevel(){
        for cell in tableView.visibleCells {
            
            let languageCell = cell as! ChangeLanguageTableCell
            
            languageCell.checkOnIcon.alpha = 0
            languageCell.backgroundColor = UIColor.clear
            
        }
    }
    
    
}

class ChangeLanguageTableCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var checkOnIcon: verifierUIImageView!
    
    
}

