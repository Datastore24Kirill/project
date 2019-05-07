//
//  MyTaskViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 25/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import SwiftPullToRefresh

class MyTaskViewController: VerifierAppDefaultViewController, MyTaskViewControllerDelegate, EmptyDataSetSource, EmptyDataSetDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var myTaskView: MyTaskView!

    
    
    //MARK: - PROPERTIES
    var model = MyTaskModel()
    var myTask: [[String: Any]]?
    var status: String?
    let resultRealm = RealmSwiftAction.listRealm()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locolizeTabBar()
        
        myTaskView.localizationView()
        myTaskView.setupFilterControl()
        tableView.backgroundColor = UIColor.clear
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        model.delegate = self
        showSpinner()
        model.setUserGeoLocation(status: status)
        myTaskView.filterControl.didSelectItemWith = { (index, title) -> () in
            print("Selected item \(index)")
            self.showSpinner()
            switch index {
            case 0:
                self.status = "ACCEPTED"
                self.model.setUserGeoLocation(status: self.status)
                self.setupEmptyTable()
            case 1:
                self.status = "VERIFIED"
                self.model.setUserGeoLocation(status: self.status)
                self.setupEmptyTable()
            case 2:
                self.status = "APPROVE"
                self.model.setUserGeoLocation(status: self.status)
                self.setupEmptyTable()
            case 3:
                self.status = "RETURNED_TO_VERIFIER"
                self.model.setUserGeoLocation(status: self.status)
                self.setupEmptyTable()
            default: break
            }
        }
        
        if let pushToken = resultRealm.first?.pushToken {
            sendPushToken(pushToken: pushToken)
        }
        
        setupPullToReloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        
    }
    
    //SETUP
    
    func setupPullToReloadTable() {
        guard
            let url = Bundle.main.url(forResource: "logo_pre", withExtension: "gif"),
            let data = try? Data(contentsOf: url) else { return }
        print("DATA \(data)")
        tableView.spr_setGIFHeader(data: data, isBig: false, height: 150) {
            
            self.model.setUserGeoLocation(status: self.status)
        }
    }
    
    func setupEmptyTable() {
        // create attributed string
        let emptyTitle = "Notasks".localized()
        let emptyAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#333333") ]
        let emptyAttrString = NSAttributedString(string: emptyTitle, attributes: emptyAttribute)
        
        var emptyDescTitle = ""
        
        switch status {
        case "ACCEPTED": emptyDescTitle = "NoTasks.ACCEPTED".localized()
        case "VERIFIED": emptyDescTitle = "Notasks.VERIFIED".localized()
        case "APPROVE": emptyDescTitle = "Notasks.APPROVE".localized()
        case "RETURNED_TO_VERIFIER": emptyDescTitle = "Notasks.RETURNED_TO_VERIFIER".localized()
        default:
            break
        }
      
        let emptyDescAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#333333") ]
        let emptyDescAttrString = NSAttributedString(string: emptyDescTitle, attributes: emptyDescAttribute)
        
        let buttonTitle = "Refresh".localized()
        let buttonAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#FFFFFF") ]
        let buttonAttrString = NSAttributedString(string: buttonTitle, attributes: buttonAttribute)
        
        
        
        
        tableView.emptyDataSetView { view in
            view.titleLabelString(emptyAttrString)
                .detailLabelString(emptyDescAttrString)
                .image(UIImage.init(named: "Logotype_small"))
                .shouldFadeIn(true)
                .buttonTitle(buttonAttrString, for: .normal)
                .buttonBackgroundImage(UIImage.init(named: "Refresh.Button"), for: .normal)
                .shouldFadeIn(true)
                .isScrollAllowed(true)
                .isTouchAllowed(true)
                .didTapDataButton {
                    print("reload")
                    self.showSpinner()
                    self.model.setUserGeoLocation(status: self.status)
                    
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
        myTask = data
        tableView.spr_endRefreshing()
        tableView.reloadData()
    }
    
}

//MARK: UITableView
extension MyTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myTask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = myTask?[indexPath.section]
        print("DATA TASK \(String(describing: data))")
        //LOCATION
        
        
        
            let myTaskCell = tableView.dequeueReusableCell(withIdentifier: "MyTaskCell", for: indexPath) as! MyTaskCell
            
            
            
            
            myTaskCell.typeTaskLabel.text = data?["orderTypeName"] as? String
            myTaskCell.titleTaskLabel.text = data?["orderName"] as? String
        
            
            myTaskCell.addressTaskLabel.text = data?["verifAddr"] as? String
            
            let orderPrice = data?["orderRate"] as? Double ?? 0
            myTaskCell.priceLabel.text = String(orderPrice) + " ₽"
        
            
            if let orderLevel = data?["orderLevel"] as? Int {
                switch orderLevel {
                case 0:
                    myTaskCell.orderLevel.image = UIImage.init(named: "Icon.Complexity")
                case 1:
                    myTaskCell.orderLevel.image = UIImage.init(named: "Icon.СomplexitySimple")
                case 2:
                    myTaskCell.orderLevel.image = UIImage.init(named: "Icon.СomplexityMedium")
                case 3:
                    myTaskCell.orderLevel.image = UIImage.init(named: "Icon.СomplexityHard")
                default: break
                }
            }
        
            //PROCENT
        
            myTaskCell.circularProgreeRing.alpha = 0
        
        
            //STATUS
        
            if let status = data?["status"] as? String {
                let statusDict = getStatus(status: status)
                myTaskCell.statusTaskLabel.text = statusDict["name"]
                if let color = statusDict["color"] {
                    myTaskCell.statusView.layer.borderColor = UIColor(color).cgColor
                    myTaskCell.statusView.layer.borderWidth = 1
                    myTaskCell.statusTaskLabel.textColor = UIColor(color)
                }
                switch status {
                case "ACCEPTED": //ACCEPTED
                    if let stepsCount = data?["stepsCount"] as? Int, stepsCount > 0,
                        let currentStep = data?["currentStep"] as? Int {
                        
                        let procent = CGFloat(((currentStep - 1) * 100) / stepsCount)
                        print("procent# \(procent)")
                        myTaskCell.circularProgreeRing.alpha = 1
                        myTaskCell.circularProgreeRing.value = procent
                        
                        
                    }
                    
                case "VERIFIED": //VERIFIED
                    myTaskCell.circularProgreeRing.alpha = 1
                    myTaskCell.circularProgreeRing.value = 100.0
                    
                case "APPROVE": //APPROVE
                    myTaskCell.circularProgreeRing.alpha = 1
                    myTaskCell.circularProgreeRing.value = 100.0
                    
                default:
                    break
                }
            }
            
            return myTaskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let data = myTask?[indexPath.section]
        
        if let orderID = data?["orderId"] as? Int,
            let orderName = data?["orderName"] as? String {
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.taskInfoVC.rawValue
            
            if let taskInfoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskInfoViewController {
                taskInfoVC.orderId = String(orderID)
                taskInfoVC.orderName = orderName
                
                taskInfoVC.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(taskInfoVC, animated: true)
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(7)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
}
