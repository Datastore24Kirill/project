//
//  TaskFilterViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import DropDown
import StepSlider

class TaskFilterViewController: VerifierAppDefaultViewController, TaskFilterModelDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var taskFilterView: TaskFilterView!
    
    //OrderLevel
    @IBOutlet weak var orderLevelTableView: UITableView!
    @IBOutlet weak var heightOfOrderLevelTable: NSLayoutConstraint!
    
    //Distance
    @IBOutlet weak var orderDistanceSlider: UISlider!
    @IBOutlet weak var orderDistanceSliderLabel: UILabel!
    
    //OrderType
    @IBOutlet weak var taskFilterCategoryTableView: TaskFilteCategoryTableView!
    

    //MARK: - PROPERTIES
    let priceDropDown = DropDown()
    let resultFilterRealm = RealmSwiftFilterAction.listRealm()
    var orderLevelArray: [[String: Any]]?
    var maxDist = 20
    var model = TaskFilterModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskFilterView.localizationView()
        setupDropDown()
        setupTimeToFilter()
        
        orderLevelTableView.delegate = self
        orderLevelTableView.dataSource = self
        orderLevelTableView.tableFooterView = UIView()
        heightOfOrderLevelTable.constant = 180
        
        
        model.delegate = self
        showSpinner()
        model.getOrderLevel()
        model.getOrderTypeCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Support Functions
    
    func setupDropDown() {
        
        //DropDownPrice
        priceDropDown.anchorView = view
        priceDropDown.dataSource = ["Отключен", "По-убыванию", "По-возрастанию"]
        priceDropDown.width = taskFilterView.priceDropDownView.frame.size.width
        priceDropDown.direction = .bottom
       
        
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 40
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        appearance.textFont = UIFont(name: "Helvetica", size: 14)!
        
        if #available(iOS 11.0, *) {
            appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        }
        
        
        priceDropDown.width =  taskFilterView.priceDropDownView.frame.size.width
        priceDropDown.bottomOffset = CGPoint(x: taskFilterView.priceDropDownView.frame.origin.x, y:taskFilterView.priceDropDownView.frame.origin.y + appearance.cellHeight * CGFloat(priceDropDown.dataSource.count))
        
        let filter = resultFilterRealm.first
        if let priceOrder = filter?.priceOrder, priceOrder.count > 0 {
            switch priceOrder {
            case "DESC":
                priceDropDown.selectRow(1)
                self.taskFilterView.priceDropDownLabel.text = priceDropDown.dataSource[1]
            case "ASC":
                priceDropDown.selectRow(2)
                self.taskFilterView.priceDropDownLabel.text = priceDropDown.dataSource[2]
            default:
                priceDropDown.selectRow(0)
                self.taskFilterView.priceDropDownLabel.text = priceDropDown.dataSource[0]
            }
        }
        
        priceDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.taskFilterView.priceDropDownLabel.text = item
            
            var priceOrder = String()
            switch index {
            case 0:
                priceOrder = ""
            case 1:
                priceOrder = "DESC"
            case 2:
                priceOrder = "ASC"
            default:
                priceOrder = ""
            }
            
            RealmSwiftFilterAction.updateRealm(priceOrder: priceOrder, dist: nil, orderTypeId: nil, orderLevel: nil, verifTimeTo: nil, available: false)
            
        }
        //
        
        
    }
    
    func setupTimeToFilter() {
        
        //Default timeToAll
        
        let filter = resultFilterRealm.first
        if let priceOrder = filter?.verifTimeTo.value {
            switch priceOrder {
            case 1:
                changeTimeToFilter(index: 1)
            case 2:
                changeTimeToFilter(index: 2)
            default:
               changeTimeToFilter(index: 0)
            }
        }
    }
    
    func changeTimeToFilter(index: Int)  {
        
        taskFilterView.timeToAllView.backgroundColor = UIColor.clear
        taskFilterView.timeToAllIcon.alpha = 0
        
        taskFilterView.timeToTodayView.backgroundColor = UIColor.clear
        taskFilterView.timeToTodayIcon.alpha = 0
        
        taskFilterView.timeTo24HoursView.backgroundColor = UIColor.clear
        taskFilterView.timeTo24HoursIcon.alpha = 0
        
        
        var verifTimeTo = 3
        switch index {
        case 1:
            taskFilterView.timeToTodayView.backgroundColor = UIColor("#E8E8FF")
            taskFilterView.timeToTodayIcon.alpha = 1
            verifTimeTo = 1
        case 2:
            
            taskFilterView.timeTo24HoursView.backgroundColor = UIColor("#E8E8FF")
            taskFilterView.timeTo24HoursIcon.alpha = 1
            verifTimeTo = 2
        default:
            taskFilterView.timeToAllView.backgroundColor = UIColor("#E8E8FF")
            taskFilterView.timeToAllIcon.alpha = 1
            verifTimeTo = 3
        }
        
        RealmSwiftFilterAction.updateRealm(priceOrder: nil, dist: nil, orderTypeId: nil, orderLevel: nil, verifTimeTo: verifTimeTo, available: false)
    }
    
    
    func setupSliderDistance() {
        
        let filter = resultFilterRealm.first
        if let distance = filter?.dist {
            orderDistanceSlider.setValue(Float(distance), animated: true)
            orderDistanceSliderLabel.text = String(distance) + " " + "km".localized()
        }
    }
    
    //
    
    //MARK: - ACTIONS
    @IBAction func priceDropDownActions(_ sender: Any) {
        print("price")
        priceDropDown.show()
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        
        RealmSwiftFilterAction.resetToDefault()
        viewWillAppear(true)
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    //ButtonForTime
    
    @IBAction func timeToAllAction(_ sender: Any) {
        changeTimeToFilter(index: 0)
    }
    
    @IBAction func timeToTodayAction(_ sender: Any) {
        changeTimeToFilter(index: 1)
    }
    
    @IBAction func timeTo24HoursAction(_ sender: Any) {
        changeTimeToFilter(index: 2)
    }
    
    //
    
    //OrderDistance
    @IBAction func orderDistanceAction(_ sender: UISlider) {
        
        
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        let distance = Int(round(sender.value))
        orderDistanceSliderLabel.text = String(distance) + " " + "km".localized()
        
        RealmSwiftFilterAction.updateRealm(priceOrder: nil, dist: Int32(distance), orderTypeId: nil, orderLevel: nil, verifTimeTo: nil, available: false)
        
    }
    //
    
    //availableForMe
    @IBAction func availableForMeAction(_ sender: UISwitch) {
        
        RealmSwiftFilterAction.updateRealm(priceOrder: nil, dist: nil, orderTypeId: nil, orderLevel: nil, verifTimeTo: nil, available: sender.isOn)
    }
    
    
    
    //MARK: - DELEGATE
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [String: Any]) {
        print("Update")
        
        orderLevelArray = data["orderLevel"] as? [[String: Any]]
        maxDist = data["maxDist"] as? Int ?? 20
        
        orderDistanceSlider.maximumValue = Float(maxDist)
        orderDistanceSlider.minimumValue = 5
        setupSliderDistance()
        orderLevelTableView.reloadData()
    }
    
    func updateInformationOfOrderType(data: [[String: Any]]) {
        print("Update")
        taskFilterCategoryTableView.reloadTable(data: data)
    }
    
}

class TaskFilterOrderLevelCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var orderLevelBackgroundView: verifierUIView!
    @IBOutlet weak var orderLevelLabel: UILabel!
    @IBOutlet weak var orderLevelButton: verifierUIButton!
    @IBOutlet weak var orderLevelIcon: verifierUIImageView!
    
    
    
}

class TaskFilterOrderTypeCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var orderLevelBackgroundView: verifierUIView!
    @IBOutlet weak var orderLevelLabel: UILabel!
    @IBOutlet weak var orderLevelButton: verifierUIButton!
    @IBOutlet weak var orderLevelIcon: verifierUIImageView!
    
    
    
}


//MARK: UITableView
extension TaskFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderLevelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "OrderLevelCell", for: indexPath) as! TaskFilterOrderLevelCell
        
        let dict = orderLevelArray?[indexPath.row]
        
        cell.orderLevelLabel.text = dict?["name"] as? String
        cell.orderLevelButton.fieldId = dict?["value"] as? Int
        
        cell.orderLevelButton.addTargetClosure(){button in
            
            let cellButton = button as? verifierUIButton
            print("button \(String(describing: cellButton?.fieldId))")
            self.resetAllOrderLevel()
            self.changeFilterOrderLevel(value: cellButton?.fieldId ?? 0)
            
        }
        
        let filter = resultFilterRealm.first
        if let orderLevel = filter?.orderLevel.value,
            let orderLevelServer = dict?["value"] as? Int {
            if orderLevel == orderLevelServer {
                cell.orderLevelBackgroundView.backgroundColor = UIColor("#E8E8FF")
                cell.orderLevelIcon.alpha = 1
            } else {
                cell.orderLevelBackgroundView.backgroundColor = UIColor.clear
                cell.orderLevelIcon.alpha = 0
            }
        } else {
            if indexPath.row == 0 {
                cell.orderLevelBackgroundView.backgroundColor = UIColor("#E8E8FF")
                cell.orderLevelIcon.alpha = 1
            }
        }
        
        return cell
    }
    
    func resetAllOrderLevel(){
        for cell in orderLevelTableView.visibleCells {
            if cell.isKind(of: TaskFilterOrderLevelCell.self){
                let orderLevelCell = cell as! TaskFilterOrderLevelCell
                
                orderLevelCell.orderLevelIcon.alpha = 0
                orderLevelCell.orderLevelBackgroundView.backgroundColor = UIColor.clear
            }
        }
    }
    
    func changeFilterOrderLevel(value: Int) {
        for cell in orderLevelTableView.visibleCells {
            if cell.isKind(of: TaskFilterOrderLevelCell.self){
                let orderLevelCell = cell as! TaskFilterOrderLevelCell
                if orderLevelCell.orderLevelButton.fieldId == value {
                    orderLevelCell.orderLevelBackgroundView.backgroundColor = UIColor("#E8E8FF")
                    orderLevelCell.orderLevelIcon.alpha = 1
                }
                
            }
        }
        
        
        RealmSwiftFilterAction.updateRealm(priceOrder: nil, dist: nil, orderTypeId: nil, orderLevel: value, verifTimeTo: nil, available: false)
    }
    
    
    
    
    
    
}
