//
//  TaskStepViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import MobileCoreServices


class TaskStepViewController: VerifierAppDefaultViewController, TaskStepViewControllerDelegate, TaskStepTextCellDelegate {
    
    
    
    
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var taskStepView: TaskStepView!
    
    //MARK: - PROPERTIES
    var orderId: String?
    var taskStepIndex: String?
    var taskStepCount: Int?
    var orderName: String?
    var model = TaskStepModel()
    var stepFields: [[String : Any]]?
    var imagePicker = verifierUIImagePickerController()
    var isMyTask = false
    var isFinal = false
    private var stepModel: StepModel? = nil
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        
        model.delegate = self
        if let _orderId = orderId, let _orderName = orderName, let _taskStepIndex = taskStepIndex {
            
            taskStepView.orderName.text = _orderName
            taskStepView.orderIdLabel.text = "№ " + _orderId
            model.getOrderStep(orderId: _orderId, taskStepIndex: _taskStepIndex)
        }
    }
    
    //MARK: - SUPPORT FUNCTION
    func validate() {
        var isValid = true
        stepModel?.stepFields.forEach({
            if !$0.validate(fieldType: $0.fieldType) {
                isValid = false
            }
        })
        if !isValid {
            showAlertError(with: "Error".localized(), message: "Error.CheckFieldsAreRequired".localized())
        }
        else {
            var params = stepModel?.setInfo()
            params!["orderId"] = orderId
            if let parameters = params {
//                showSpinner()
//                taskStepView.nextButton.isUserInteractionEnabled = false
                print("PARAMMM \(parameters)")
                let taskStepInfo = model.resultTaskStepRealm.filter("taskId = \(orderId) AND taskStepIndex = \(taskStepIndex)").first
                
                let taskStepDict = convertToDictionary(text: taskStepInfo!.taskStep ?? "")
                print("TASK STEP \(taskStepDict)")
//                model.orderStepTask(params: parameters)
            }
        }
     
    }
    
    func openDialogCamera(isPhoto: Bool, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: (isPhoto == true ? "GetPhoto".localized() : "GetVideo".localized()) , message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: { _ in
            self.openCamera(isPhoto: isPhoto, indexPath: indexPath, section: nil)
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func openDialogCamera(isPhoto: Bool, section: Int) {
        
        let alert = UIAlertController(title: (isPhoto == true ? "GetPhoto".localized() : "GetVideo".localized()) , message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: { _ in
            self.openCamera(isPhoto: isPhoto, indexPath: nil, section: section)
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Open the camera
    func openCamera(isPhoto: Bool, indexPath: IndexPath?, section: Int?){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            if isPhoto == true {
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.isPhoto = true
            } else {
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.isPhoto = false
            }
            if let IP = indexPath {
                imagePicker.indexPath   = IP
                imagePicker.section     = nil
            }
            else {
                imagePicker.section     = section!
                imagePicker.indexPath   = nil
            }
            
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Error".localized(), message: "Error.Camera".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didShowPreviousViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        if isMyTask {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func chatButtonAction(_ sender: Any) {
        
        let storyboard = InternalHelper.StoryboardType.jivoSite.getStoryboard()
        let indentifier = ViewControllers.chatVC.rawValue
        
        if let chatVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? ChatViewController {
            if let orderIdResult = orderId {
                chatVC.orderId = orderIdResult
                chatVC.isShowBackButton = true
                chatVC.orderName = orderName
                chatVC.orderType = taskStepView.orderType.text
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
            
            
        }
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        print("123")
        if !isFinal {
            validate()
        } else if isFinal {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    
    @IBAction func didChangeSegmentControl(_ sender: verifierUISegmentedControl) {
        let indexSegmented = sender.selectedSegmentIndex
        var isHaveUnderFields = false
        switch indexSegmented {
        case 0:
            if let IP = sender.indexPath {
                if sender.isAnswerYes! {
                    stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].isAnswerYes = true
                }
                else {
                    stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].isAnswerYes = true
                }
            }
            else {
                stepModel?.stepFields[sender.section!].isAnswerYes = true
                if (stepModel?.stepFields[sender.section!].fieldUnderYesList.count)! > 0 {
                    isHaveUnderFields = true
                }
            }
        case 1:
            if let IP = sender.indexPath {
                if sender.isAnswerYes! {
                    stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].isAnswerYes = nil
                }
                else {
                    stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].isAnswerYes = nil
                }
            }
            else {
                stepModel?.stepFields[sender.section!].isAnswerYes = nil
            }
        case 2:
            if let IP = sender.indexPath {
                if sender.isAnswerYes! {
                    stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].isAnswerYes = false
                }
                else {
                    stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].isAnswerYes = false
                }
            }
            else {
                stepModel?.stepFields[sender.section!].isAnswerYes = false
                if (stepModel?.stepFields[sender.section!].fieldUnderNoList.count)! > 0 {
                    isHaveUnderFields = true
                }
            }
        default:
            print("/////////////////////////////default segment Control")
        }
        
        tableView.reloadData()
        if isHaveUnderFields {
            tableView.scrollToRow(at: IndexPath(row: 0, section: sender.section!), at: .middle, animated: false)
        }
        else {
            if let IP = sender.indexPath {
                tableView.scrollToRow(at: IP, at: .middle, animated: true)
            }
            else {
                tableView.setNeedsLayout()
                tableView.layoutIfNeeded()
                let rect = tableView.rectForHeader(inSection: sender.section!)
                let contentOffsetY = rect.origin.y
                if contentOffsetY > tableView.contentSize.height - tableView.frame.height {
                    tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.height), animated: false)
                }
            }
        }
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        taskStepView.nextButton.isUserInteractionEnabled = true
        super.hideSpinner()
    }
    
    func updateInformation(data: String) {
        print("Update")
        let taskStepDict = convertToDictionary(text: data)
        print("STEPP \(taskStepDict)")
        stepModel = StepModel.init(data: taskStepDict ?? [String: Any]())
        tableView.reloadData()
        
        
        if let stepIndex = stepModel?.stepIndex, let stepsCount = taskStepCount {
             taskStepView.orderStep.text = "Шаг \(String(stepIndex)) из \(String(stepsCount))"
        }
        
        
        if let stepName = stepModel?.stepName {
            taskStepView.orderType.text = stepName
        }
        taskStepView.stepInfoButton.alpha = 0
        taskStepView.stepInfoButton.isUserInteractionEnabled = false
        if let stepInfo = stepModel?.stepInfo, stepInfo.count > 0 {
            showTaskStepInfo(info: stepInfo)
        }
        if data.count > 0 {
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            showAlertError(with: "Error".localized(), message: "Error.LoadStepError".localized())
        }
        
    }
    
    func textViewChangeText(indexPath: IndexPath?, text: String, section: Int?) {
        if let IP = indexPath {
            if (stepModel?.stepFields[IP.section].isAnswerYes)! {
                stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].answerText = text
            }
            else {
                stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].answerText = text
            }
        }
        else {
            stepModel?.stepFields[section!].answerText = text
        }
    }
    
    func loadNextStep() {
//        if let orderIdResult = orderId {
//            showSpinner()
//            model.getOrderStep(orderId: orderIdResult)
//        }
    }
    
    func showLastStep(){
        
        
        showRateTaskDialog(){ rating in
            let params: [String: Any] = ["orderId" : self.orderId ?? "0", "orderRating" : Float(rating)]
            self.model.orderRate(params: params)
        }
        isFinal = true
        taskStepView.nextButton.setTitle("Close".localized(), for: .normal)
    }
    
    //MARK: - TaskStepViewControllerDelegate
    func updatePhoto(link: String, image: UIImage, indexPath: IndexPath?, section: Int?) {
        if let IP = indexPath {
            if (stepModel?.stepFields[IP.section].isAnswerYes)! {
                stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].answerImageLink = link
                stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].answerImage     = image
            }
            else {
                stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].answerImageLink  = link
                stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].answerImage      = image
            }
        }
        else {
            stepModel?.stepFields[section!].answerImageLink = link
            stepModel?.stepFields[section!].answerImage     = image
        }
        tableView.reloadData()
        if let IP = indexPath {
            tableView.setNeedsLayout()
            tableView.layoutIfNeeded()
            tableView.scrollToRow(at: IP, at: .bottom, animated: false)
        }
        else {
            tableView.setNeedsLayout()
            tableView.layoutIfNeeded()
            let rect = tableView.rectForHeader(inSection: section!)
            let contentOffsetY = rect.origin.y
            if contentOffsetY > tableView.contentSize.height - tableView.frame.height {
                tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.height), animated: false)
            }
            else {
                tableView.setContentOffset(CGPoint(x: 0, y: rect.origin.y), animated: false)
            }
        }
    }
    
    func updateVideo(link: String, url: URL, video: Data, indexPath: IndexPath?, section: Int?) {
        let image = generateThumbImage(url: url)
        if let IP = indexPath {
            if (stepModel?.stepFields[IP.section].isAnswerYes)! {
                stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].answerVideoLink = link
                stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].answerVideoURL  = url
                stepModel?.stepFields[IP.section].fieldUnderYesList[IP.row].answerVideoImage  = image
            }
            else {
                stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].answerVideoLink  = link
                stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].answerVideoURL   = url
                stepModel?.stepFields[IP.section].fieldUnderNoList[IP.row].answerVideoImage  = image
            }
        }
        else {
            stepModel?.stepFields[section!].answerVideoLink     = link
            stepModel?.stepFields[section!].answerVideoURL      = url
            stepModel?.stepFields[section!].answerVideoImage    = image
        }
        tableView.reloadData()
        if let IP = indexPath {
            tableView.setNeedsLayout()
            tableView.layoutIfNeeded()
            tableView.scrollToRow(at: IP, at: .bottom, animated: false)
        }
        else {
            tableView.setNeedsLayout()
            tableView.layoutIfNeeded()
            let rect = tableView.rectForHeader(inSection: section!)
            let contentOffsetY = rect.origin.y
            if contentOffsetY > tableView.contentSize.height - tableView.frame.height {
                tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.height), animated: false)
            }
            else {
                tableView.setContentOffset(CGPoint(x: 0, y: rect.origin.y), animated: false)
            }
        }
    }
}

//MARK: UITableView
extension TaskStepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return stepModel?.stepFields.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let stepField = stepModel?.stepFields[section]
        if stepField?.fieldType != .check {
            return 0
        }
        else {
            if stepField?.isAnswerYes != nil {
                if (stepField?.isAnswerYes)! {
                    return (stepField?.fieldUnderYesList.count)!
                }
                else {
                    return (stepField?.fieldUnderNoList.count)!
                }
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepField = (stepModel?.stepFields[indexPath.section])!
        let fieldUnder: FieldUnder!
        if (stepField.isAnswerYes)! {
            fieldUnder = stepField.fieldUnderYesList[indexPath.row]
        }
        else {
            fieldUnder = stepField.fieldUnderNoList[indexPath.row]
        }
        switch fieldUnder.fieldType {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TaskStepTextCell
            cell.setupUI(stepField: fieldUnder, indexPath: indexPath, section: nil)
            cell.delegate = self
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! TaskStepPhotoCell
            cell.setupUI(stepField: fieldUnder, indexPath: indexPath, section: nil)
            //                Кнопки
            cell.takePhotoButton.addTargetClosure(){ button in
                self.openDialogCamera(isPhoto: true, indexPath: indexPath)
            }
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! TaskStepVideoCell
            cell.setupUI(stepField: fieldUnder, indexPath: indexPath, section: nil)
            if let image = fieldUnder.answerVideoImage {
                cell.videoImageView.image = image
            }
            //Кнопки
            cell.takeVideoButton.addTargetClosure(){ button in
                self.openDialogCamera(isPhoto: false, indexPath: indexPath)
            }
            return cell
        case .check:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! TaskStepCheckCell
            cell.setupUI(stepField: fieldUnder, indexPath: indexPath, section: nil, answerYes: stepField.isAnswerYes)
            return cell
        case .mark:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCell", for: indexPath) as! TaskStepMarkCell
            cell.setupUI(stepField: fieldUnder, indexPath: indexPath, section: nil)
            cell.cosmosView.didFinishTouchingCosmos = { rating in
                fieldUnder.answerMark = rating
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let stepField = (stepModel?.stepFields[section])!
        switch stepField.fieldType {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TaskStepTextCell
            cell.setupUI(stepField: stepField, indexPath: nil, section: section)
            cell.delegate = self
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! TaskStepPhotoCell
            cell.setupUI(stepField: stepField, indexPath: nil, section: section)
            //Кнопки
            cell.takePhotoButton.addTargetClosure(){ button in
                self.openDialogCamera(isPhoto: true, section: section)
            }
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! TaskStepVideoCell
            cell.setupUI(stepField: stepField, indexPath: nil, section: section)
            if let image = stepField.answerVideoImage {
                cell.videoImageView.image = image
            }
//            if let url = stepField.answerVideoURL {
//                cell.videoImageView.image = generateThumbImage(url: url)
//            }
            //Кнопки
            cell.takeVideoButton.addTargetClosure(){ button in
                self.openDialogCamera(isPhoto: false, section: section)
            }
            return cell
        case .check:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell") as! TaskStepCheckCell
            cell.setupUI(stepField: stepField, indexPath: nil, section: section, answerYes: nil)
            return cell
        case .mark:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCell") as! TaskStepMarkCell
            cell.setupUI(stepField: stepField, indexPath: nil, section: section)
            cell.cosmosView.didFinishTouchingCosmos = { rating in
                stepField.answerMark = rating
            }
            return cell
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension TaskStepViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        let pickerVer = picker as! verifierUIImagePickerController
        
        if let isPhoto =  pickerVer.isPhoto, isPhoto == true {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            self.showSpinner()
            print(selectedImage)
            model.uploadPhoto(image: selectedImage, indexPath: pickerVer.indexPath, section: pickerVer.section)
        } else if let isPhoto =  pickerVer.isPhoto, isPhoto == false {
            self.showSpinner()
            print("info \(info)")
            if let fileURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                
                do {
                    let videoData = try Data(contentsOf: fileURL)
                    model.uploadVideo(url: fileURL, video: videoData, indexPath: pickerVer.indexPath, section: pickerVer.section)
                } catch {
                    print(error)
                }
            }
        }
    
        
        
        
        
        
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
