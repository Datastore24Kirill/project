//
//  TaskStepTableViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 23/04/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import RealmSwift

class TaskStepTableViewController: VerifierAppDefaultViewController, TaskStepTableViewControllerDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var taskStepTableView: TaskStepTableView!
    
    //MARK: - PROPERTIES
    var orderId: String?
    var orderName: String?
    var model = TaskStepTableModel()
    var taskStep: [[String: Any?]]?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locolizeTabBar()
        
        taskStepTableView.localizationView()
//        showSpinner()
       
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
        model.delegate = self
        taskStepTableView.orderId.text = "№ " + (orderId ?? "0")
        
        if let _orderid = orderId, let _orderName = orderName {
            
            taskStepTableView.orderName.text = _orderName
            model.getTaskInformation(orderId: Int(_orderid)!)
            model.getTaskSteps(orderId: Int(_orderid)!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - ACTIONS
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformationTask(data: String) {
        let informationDictionary = convertToDictionary(text: data)
        print(informationDictionary)
        
        taskStepTableView.orderRate.text = (String((informationDictionary?["orderRate"] as? Int) ?? 0)) + " ₽"
        taskStepTableView.orderName.text = (informationDictionary?["orderName"] as? String) ?? "Не указано"
        taskStepTableView.orderType.text = informationDictionary?["orderTypeName"] as? String ?? "Другое"
        
        if let _orderLevel = informationDictionary?["orderLevel"] as? Int{
            switch _orderLevel {
            case 0:
                taskStepTableView.orderLevel.image = UIImage.init(named: "Icon.ComplexityBlack")
            case 1:
                taskStepTableView.orderLevel.image = UIImage.init(named: "Icon.СomplexityBlackSimple")
            case 2:
                taskStepTableView.orderLevel.image = UIImage.init(named: "Icon.СomplexityBlackMedium")
            case 3:
                taskStepTableView.orderLevel.image = UIImage.init(named: "Icon.СomplexityBlackHard")
            default: break
            }
        }
        
    }
    
    func updateInformationStep(data: Results<TaskStepListDB>) {
        
        print(data)

        var stepInfo = [[String:Any?]]()
        for value in data {
            let taskStepDict = convertToDictionary(text: value.taskStep ?? "")
           
            let dict: [String: Any?] = ["taskStepIndex":value.taskStepIndex, "stepName" : taskStepDict?["stepName"], "isFinish" :value.needSendToTheServer]
            stepInfo.append(dict)
        }
        taskStep = stepInfo
        tableView.reloadData()
    }
    



}

//MARK: UITableView
extension TaskStepTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskStep?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = taskStep?[indexPath.section]
        print("DATA TASK \(String(describing: data))")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTaskStepOne", for: indexPath) as! TaskStepTableCell
        
        cell.numberOfTaskLabel.text = "Шаг #\(data?["taskStepIndex"] as? Int ?? 0)"
        cell.nameOfTaskLabel.text = data?["stepName"] as? String
        
        if let isFinish = data?["isFinish"] as? Bool {
            if isFinish == true {
                cell.doneImageView.alpha = 1
            } else {
                cell.doneImageView.alpha = 0
            }
        }
        
        // add border and color
        
        //        dashboardCell.layer.borderColor = UIColor("#EFEFEF").cgColor
        //        dashboardCell.layer.borderWidth = CGFloat(0.72)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let data = taskStep?[indexPath.section]
        
        let taskStepIndex = data?["taskStepIndex"] as? Int ?? 0
        
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.taskStepVC.rawValue
        
        if let taskStepVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskStepViewController {
           
            taskStepVC.orderId = orderId
            taskStepVC.orderName = orderName
            taskStepVC.taskStepIndex = String(taskStepIndex)
            taskStepVC.taskStepCount = taskStep?.count ?? 0
            self.navigationController?.pushViewController(taskStepVC, animated: true)
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
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

class  TaskStepTableCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var numberOfTaskLabel: UILabel!
    @IBOutlet weak var nameOfTaskLabel: UILabel!
    @IBOutlet weak var doneImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
