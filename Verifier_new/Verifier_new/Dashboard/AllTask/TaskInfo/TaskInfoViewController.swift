//
//  TaskInfoViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 22/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TaskInfoViewController: VerifierAppDefaultViewController, TaskInfoViewControllerDelegate {

    //MARK: - OUTLETS
    @IBOutlet var taskInfoView: TaskInfoView!
    
    //MARK: - PROPERTIES
    var orderId: String?
    var orderName: String?
    var taskLat: Float?
    var taskLong: Float?
    var isNewOrder = true
    var showNextButton = false
    var htmlInstruction: String?
    var taskInfo = [String: Any]()
    let resultFilterRealm = RealmSwiftTaskAction.listRealm()
  
    
    var model = TaskInfoModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskInfoView.localizationView()
        setupData()
        
        if let orderIdResult = orderId {
            showSpinner()
            model.delegate = self
            model.getOrder(orderId: orderIdResult)
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    //MARK: - SUPPORTACTION
    
    func changeHeightOfNextButton(){
        if !showNextButton {
            taskInfoView.heightOfNexButton.constant = 0
        } else {
            taskInfoView.heightOfNexButton.constant = 50
        }
    }
    
    func setupData() {
        taskInfoView.mapButton.isUserInteractionEnabled = false
        taskInfoView.mapButton.alpha = 0
        
        taskInfoView.orderId.text = "№ " + (orderId ?? "0")
        
        changeHeightOfNextButton()
        
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        guard let lat = taskLat,
            let long = taskLong  else {
            return
        }
        googleMapsBuildARouteFromPoint(lat: lat, lng: long, name: orderName ?? "")
    }
    
    @IBAction func helpButtonAction(_ sender: Any) {
        print("show instruction")
        if let instruction = htmlInstruction {
            let storyboard = InternalHelper.StoryboardType.instruction.getStoryboard()
            let indentifier = ViewControllers.instructionVC.rawValue
            
            if let instructionVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? InstructionViewController {
                instructionVC.htmlString = instruction
                instructionVC.showNextButton = false
                self.navigationController?.pushViewController(instructionVC, animated: true)
                
            }
        } else {
            showAlertError(with: "Error".localized(), message: "Error.Instruction".localized())
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        
        if let orderIdResult = orderId {
            
            let orderInfo = resultFilterRealm.filter("id = \(orderIdResult)").first
            print("IDD: \(orderInfo?.id)")
            
            isNewOrder = orderInfo?.id == nil ? true : false
            
            if isNewOrder {
                print("NEW TASK")
                
                RealmSwiftTaskAction.updateRealm(id: orderId, taskInformation: convertToJSONString(object: taskInfo), isSendToTheServer: nil, needSendToTheServer: nil)
                
                model.getOrderStepList(orderId: orderIdResult, orderAccept: true)
                
                
            } else {
                print("OLD TASK")
                
                if let string = orderInfo?.taskInformation {
                    
                    let decodedString = convertToDictionary(text: string)
                    print("dicc \(decodedString)")
                    print(decodedString?["orderName"])
                }
             
                model.orderAccept(orderId: orderIdResult)
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
    
    func updateInformation(data: [String: Any]) {
        print("Update")
        
        taskInfo = data
     
        taskInfoView.taskInfoLabel.text = data["orderComment"] as? String
        taskInfoView.taskAddressLabel.text = data["verifAddr"] as? String
        
        if let verifTimeTo = data["verifTimeTo"] as? Int {
            let taskDate = Date(timeIntervalSince1970: Double(verifTimeTo))
            let dateFormatter = DateFormatter()
            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
            print(localTimeZoneAbbreviation)
            dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd MMMM YYYY" //Specify your format that you want
            let taskDateString = dateFormatter.string(from: taskDate)
            
            taskInfoView.verifTimeToLabel.text = taskDateString
            taskInfoView.orderRate.text = (String((data["orderRate"] as? Int) ?? 0)) + " ₽"
            taskInfoView.orderName.text = (data["orderName"] as? String) ?? "Не указано"
            taskInfoView.orderType.text = data["orderTypeName"] as? String ?? "Другое"
            
            if let _orderLevel = data["orderLevel"] as? Int{
                switch _orderLevel {
                case 0:
                    taskInfoView.orderLevel.image = UIImage.init(named: "Icon.ComplexityBlack")
                case 1:
                    taskInfoView.orderLevel.image = UIImage.init(named: "Icon.СomplexityBlackSimple")
                case 2:
                    taskInfoView.orderLevel.image = UIImage.init(named: "Icon.СomplexityBlackMedium")
                case 3:
                    taskInfoView.orderLevel.image = UIImage.init(named: "Icon.СomplexityBlackHard")
                default: break
                }
            }
            
            //GET DAYS
            let calendar = Calendar.current
            let currentDate = Date()
            let dateTask = calendar.startOfDay(for: taskDate)
            let dateCurrentDay = calendar.startOfDay(for: currentDate)
            
            let components = calendar.dateComponents([.day], from: dateCurrentDay, to: dateTask).day
            if let days = components {
                if days < 0 {
                    taskInfoView.verifTimeToDaysLabel.text = "0 дней"
                    taskInfoView.verifTimeToDaysLabel.textColor = UIColor.red
                } else {
                    taskInfoView.verifTimeToDaysLabel.text = String(days) + " " + dayStringFromNumberOfDays(days)
                }
                
            } else {
                 taskInfoView.verifTimeToDaysLabel.text = ""
            }
            //
            
            //MAPS
            if let verifAddrLatitude = data["verifAddrLatitude"] as? Double,
                let verifAddrLongitude = data["verifAddrLongitude"] as? Double{
                taskLat = Float(verifAddrLatitude)
                taskLong = Float(verifAddrLongitude)
                taskInfoView.mapButton.isUserInteractionEnabled = true
                taskInfoView.mapButton.alpha = 1
                
            }
            
            //INSTRUCTION
            
            if let instruction = data["instruction"] as? String {
                htmlInstruction = instruction
            }
            
            //STATUS
            
            if let status = data["status"] as? String {
                let statusDict = getStatus(status: status)
                taskInfoView.statusLabel.text = statusDict["name"]
                if let color = statusDict["color"] {
                    taskInfoView.statusView.layer.borderColor = UIColor(color).cgColor
                    taskInfoView.statusView.layer.borderWidth = 1
                    taskInfoView.statusLabel.textColor = UIColor(color)
                }
                
                switch status {
                case "CREATED": //CREATE
                    taskInfoView.nextButton.setTitle("Task.getOrder".localized(), for: .normal)
                    isNewOrder = true
                    showNextButton = true
                case "ACCEPTED": //ACCEPTED
                    taskInfoView.nextButton.setTitle("Task.nextScreen".localized(), for: .normal)
                    isNewOrder = false
                    showNextButton = true
                    
                    
                    
                case "VERIFIED": //VERIFIED
                    isNewOrder = false
                    showNextButton = false
                    
                case "APPROVE": //APPROVE
                    isNewOrder = false
                    showNextButton = false
                    
                case "RETURNED_TO_VERIFIER": //RETURNED
                    taskInfoView.nextButton.setTitle("Task.nextScreen".localized(), for: .normal)
                    isNewOrder = false
                    showNextButton = true
                    
                default:
                    break
                }
                
                
                if let orderIdResult = orderId,
                    (status == "CREATED" || status == "VERIFIED") {
                    let orderInfo = resultFilterRealm.filter("id = \(orderIdResult)").first
                    print("IDD: \(orderInfo?.id)")
                    
                    if orderInfo?.id == nil {
                        taskInfoView.nextButton.setTitle("Task.getOrder".localized(), for: .normal)
                        isNewOrder = true
                        showNextButton = true
                    } else {
                        taskInfoView.nextButton.setTitle("Task.nextScreen".localized(), for: .normal)
                        isNewOrder = false
                        showNextButton = true
                    }
                } else if let orderIdResult = orderId,
                    status == "ACCEPTED" {
                    
                    let orderInfo = resultFilterRealm.filter("id = \(orderIdResult)").first
                    if orderInfo?.id == nil {
                        print("need load to DB")
                        RealmSwiftTaskAction.updateRealm(id: orderId, taskInformation: convertToJSONString(object: taskInfo), isSendToTheServer: nil, needSendToTheServer: nil)
                        model.getOrderStepList(orderId: orderIdResult, orderAccept: false)
                    }
                    
                }
                
               
                changeHeightOfNextButton()
                
            }
            
           
            
        }
        
        taskInfoView.customerNameLabel.text = data["customerName"] as? String
    }
    
    func updateInformationStepList(data: [[String: Any]], orderAccept: Bool) {
        print("Update List Steps")
        
        if let orderIdResult = orderId {
            var stepIndex = 1
            
            for value in data {
                print("STEP INDEX: \(stepIndex)")
                print("VALUE \(value)")
                RealmSwiftTaskStepListAction.updateRealm(taskId: orderIdResult, taskStepIndex: String(stepIndex), taskStep: convertToJSONString(object: value), isSendToTheServer: nil, needSendToTheServer: nil)
                stepIndex += 1
            }
            
            if orderAccept {
                model.orderAccept(orderId: orderIdResult)
            }
            
        }
        
      
    }
    
    func getOrderStep(isMyTask: Bool) {
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.taskStepTableVC.rawValue
        
        if let taskStepTableVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskStepTableViewController {
            print("orderId \(orderId) orderName \(orderName)")
            taskStepTableVC.orderId = orderId
            taskStepTableVC.orderName = orderName
            self.navigationController?.pushViewController(taskStepTableVC, animated: true)
            
        }
    }
    
    
}
