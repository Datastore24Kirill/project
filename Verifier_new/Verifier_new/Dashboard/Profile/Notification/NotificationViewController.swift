//
//  NotificationViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class NotificationViewController: VerifierAppDefaultViewController, UITableViewDelegate, UITableViewDataSource, NotificationModelDelegate {
    
    

    
    //MARK: - OUTLETS
    @IBOutlet var notificationView: NotificationView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - PROPERTIES
    let cellReuseIdentifier = "NotificationСell"
    var tableArray = [[[String: Any]](),[[String: Any]]()]
    
    //FIXME: - Убирать если нет нихера
    var section = ["Сегодня","Ранее"]
    var model = NotificationModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationView.localizationView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        model.delegate = self
        model.fetchNotification()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - ACTIONS
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func readAllButtonAction(_ sender: Any) {
        model.notificationAllRead()
    }
    
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    
    
    func updateInformation(data: [[String: Any]]) {
        
        //For Start Date
        tableArray = [[[String: Any]](),[[String: Any]]()]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let startOfDay = calendar.startOfDay(for: Date())
        
        //For End Date
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = calendar.date(byAdding: components, to: startOfDay)
        
        let startDayTimeStamp = Int64((startOfDay.timeIntervalSince1970).rounded())
        let endDayTimeStamp = Int64((endOfDay!.timeIntervalSince1970).rounded())
        print(startDayTimeStamp)
        print(endDayTimeStamp)
        
        
        data.filter({($0["date"] as! Int64) >= startDayTimeStamp && ($0["date"] as! Int64) <= endDayTimeStamp}).forEach {
            print($0)
            tableArray[0].append($0)
        }
        
        data.filter({($0["date"] as! Int64) > endDayTimeStamp || ($0["date"] as! Int64) < startDayTimeStamp}).forEach {
            print($0)
            tableArray[1].append($0)
        }
        
        print(tableArray)
        
        tableView.reloadData()
        
    }

    //MARK UITableViewDELEGATE
    // number of rows in table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.tableArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableArray[section].count > 0 {
            return self.section[section]
        } else {
            return nil
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableArray[section].count
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NotificationTableCell
        // set the text from the data model
        let dict = self.tableArray[indexPath.section][indexPath.row]
        
        print("dict \(dict)")
    
        
        cell.notificationLabel.text = dict["messageHeader"] as? String
        cell.descriptionLabel.text = dict["messageText"] as? String
        
   
        
        if let date = dict["date"] as? Int {
            let taskDate = Date(timeIntervalSince1970: Double(date))
            let dateFormatter = DateFormatter()
            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
            print(localTimeZoneAbbreviation)
            dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd MMMM YYYY" //Specify your format that you want
            let taskDateString = dateFormatter.string(from: taskDate)
            
            cell.dateLabel.text = taskDateString
            
            
        }
        
        if let isRead = dict["isRead"] as? Int {
            switch isRead {
            case 0: cell.roundImageView.image = UIImage.init(named: "Notification.RoundNotRead")
            case 1: cell.roundImageView.image = UIImage.init(named: "Notification.Round")
            default: cell.roundImageView.image = UIImage.init(named: "Notification.Round")
            }
            
        }
        
       
        
        if let notificationType = dict["notificationType"] as? String {
            switch notificationType {
            case "ORDER_NOTIFICATION": cell.backgroundColor = UIColor("#d2e2fe")
            case "MESSAGE": cell.backgroundColor = UIColor("#eeeeee")
            case "NEWS_NOTIFICATION": cell.backgroundColor = UIColor("#e1ffed")
            case "SYSTEM_NOTIFICATION": cell.backgroundColor = UIColor("#ffd7d7")
            default: break
            }
        }
        
        if let event = dict["action"] as? String {
            
            switch event {
            case "OPEN_ORDER":
                cell.nextButton.alpha = 1
                cell.nextButton.addTargetClosure{ button in
                    if let orderId = dict["orderId"] as? Int
                    {
                        
                        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
                        let indentifier = ViewControllers.taskInfoVC.rawValue
                        
                        if let taskInfoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskInfoViewController {
                            taskInfoVC.orderId = String(orderId)
                            taskInfoVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(taskInfoVC, animated: true)
                            
                        }
                    }
                }
            case "OPEN_PROFILE":
                cell.nextButton.alpha = 1
                cell.nextButton.addTargetClosure{ button in
                self.navigationController?.popViewController(animated: false)
                    
                }
                
            case "CHANGE_PASSWORD":
                cell.nextButton.alpha = 1
                cell.nextButton.addTargetClosure{ button in
                    let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
                    let indentifier = ViewControllers.changePasswordVC.rawValue
                    
                    if let changePasswordVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? ChangePasswordViewController {
                        self.navigationController?.pushViewController(changePasswordVC, animated: true)
                        
                    }
                }
                
            case "OPEN_BROWSER":
                cell.nextButton.alpha = 1
                if let link = dict["link"] as? String {
                    cell.nextButton.addTargetClosure{ button in
                        guard let url = URL(string: link) else {
                            return //be safe
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                
            default:
                cell.nextButton.alpha = 0
            }
        }
        
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let read = UITableViewRowAction(style: .normal, title: "Read".localized()) { action, index in
            print("favorite button tapped")
            let dict = self.tableArray[indexPath.section][indexPath.row]
            if let cellId = dict["id"] as? Int {
                self.model.notificationRead(notificationId: cellId)
                
            }
            
        }
        read.backgroundColor = .orange
        
        
        return [read]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

class NotificationTableCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var roundImageView: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}
