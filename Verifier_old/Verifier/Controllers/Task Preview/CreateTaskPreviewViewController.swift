//
//  CreateTaskPreviewViewController.swift
//  Verifier
//
//  Created by iPeople on 08.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

protocol OrderFieldProtocol: class {
    func addNewPhoto(field: Field)
    func addNewVideo(field: Field)
    func addNewDescription(field: Field)
    func addNewCheck(field: Field)
    func addNewMark(field: Field)
}

protocol CreateTaskPreviewControllerOutput: class {
    func getOrderData(orderId: Int)
    func addOrder(order: NewOrder)
    func verifyOrder(order: NewOrder, orderId: Int)
    func orderApproval(orderId: Int)
    func orderReturn(orderId: Int, reason: String)

    func showMediaActionSheet()
    func showChooseVideoActionSheet()
    func showVerifierPopUoView()
    func popUpDidPressOKButton()
    func popUpDidPressHidePopUpButton()
    func navigateToDashboard()
    func navigateToChat(taskID: String)
}

protocol CreateTaskPreviewControllerInput: class {
    func provideOrderData(success: Bool, order: NewOrder, error: [String: Any]?)
    func provideAddOrderResponse(success: Bool, errorTitle: String, errorMessage: String)
    func provideOrderVerifierResponse(success: Bool, errorTitle: String, errorMessage: String)
    func provideOrderApprovalResponse(success: Bool, errorTitle: String, errorMessage: String)
    func provideOrderReturnResponse(success: Bool, errorTitle: String, errorMessage: String)
}

class CreateTaskPreviewViewController: VerifierAppDefaultViewController {

    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var orderFieldsTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!

    @IBOutlet weak var hideButtonViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var showButtonViewConstraint: NSLayoutConstraint!

    var presenter: CreateTaskPreviewControllerOutput!
    var newOrder = NewOrder()
    var navTitle = "My Orders".localized()
    var orderId = -1
    var orderStatus = 0
    var fromDashboard = false
    var picker = UIImagePickerController()
    var cellCount = 0
    
    
    
    var selectedIndex = 0
    var selectedField = Field()

    // MARK: UIViewController Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        CreateTaskPreviewAssembly.sharedInstance.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self

        registrNibFiles()
        localizeUIElement()
        getData()
        prepareUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func registrNibFiles() {
        orderFieldsTableView.register(R.nib.orderInfoTableViewCell)
        orderFieldsTableView.register(R.nib.orderDateTableViewCell)
        orderFieldsTableView.register(R.nib.orderDescriptionTableViewCell)
        orderFieldsTableView.register(R.nib.orderMapTableViewCell)
        orderFieldsTableView.register(R.nib.orderFieldsTableViewCell)
        orderFieldsTableView.register(R.nib.orderTextTableViewCell)
        orderFieldsTableView.register(R.nib.orderCheckTableViewCell)
        orderFieldsTableView.register(R.nib.previewTextTableViewCell)
        orderFieldsTableView.register(R.nib.previewPhotoTableViewCell)
        orderFieldsTableView.register(R.nib.previewVideoTableViewCell)
        orderFieldsTableView.register(R.nib.orderMarkTableViewCell)
    }

    // MARK: - UI
    func prepareUI() {
        orderFieldsTableView.rowHeight = UITableViewAutomaticDimension
        orderFieldsTableView.estimatedRowHeight = UITableViewAutomaticDimension

        doneButton.backgroundColor = UIColor.verifierBlueColor()
        //doneButton.layer.cornerRadius = 5.0
        doneButton.alpha = 1.0
        doneButton.isEnabled = true
        doneButton.layer.masksToBounds = true

        cancelButton.backgroundColor = UIColor.verifierBlueColor()
        approveButton.backgroundColor = UIColor.verifierBlueColor()

        navTitleLabel.text = ""
    }

    func setupButtonsLayout() {

        switch orderStatus {
        case 1:
            showButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)
            hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
        case 2:
            if newOrder.isMyOrder {
                showButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)
                hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
            } else {
                showButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
                hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)

                cancelButton.isHidden = true
                approveButton.isHidden = true
                doneButton.isHidden = false
            }
        case 3:
            if newOrder.isMyOrder {
                showButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
                hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)

                cancelButton.isHidden = false
                approveButton.isHidden = false
                doneButton.isHidden = true
            } else {
                showButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)
                hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
            }
        default:
            if newOrder.isMyOrder {
                showButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)
                hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
            } else {
                showButtonViewConstraint.priority = UILayoutPriority(rawValue: 999)
                hideButtonViewConstraint.priority = UILayoutPriority(rawValue: 333)

                cancelButton.isHidden = true
                approveButton.isHidden = true
                doneButton.isHidden = false
            }
        }

        self.doneButton.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }

    func localizeUIElement() {
        doneButton.setTitle("Done".localized(), for: .normal)
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        approveButton.setTitle("Approve".localized(), for: .normal)
    }

    func getData() {
        if self.orderId != -1 {
            showSpinner()
            self.presenter.getOrderData(orderId: self.orderId)
            
        } else {
            setupButtonsLayout()
        }
    }

    func clearSelectedValue() {
        self.selectedField = Field()
        self.selectedIndex = 0
    }

    private func isAllFieldsFilled() -> Bool {
        var res = true

        newOrder.fields.forEach { (field) in
            switch field.type.lowercased() {
            case "txt":
                if field.data.count == 0 {
                    res = false
                }
            case "photo":
                field.photoArray.forEach({ (image) in
                    if image == nil {
                        res = false
                    }
                })
            case "video":
                if field.videoData == nil {
                    res = false
                }
            case "mark":
                if field.data.count == 0 {
                    res = false
                }
            case "check":
                if field.data.count == 0 {
                    res = false
                } 
            default:
                break
            }
        }

        return res
    }

    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIButton) {
        
        for controller in (self.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? SideMenuViewController {
                dashboardVC.backFromDetail = self.fromDashboard
                _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }
        for controller in (self.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                dashboardVC.backFromDetail = self.fromDashboard
                _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didPressMenuButton(_ sender: UIButton) {
        openMenu()
    }

    @IBAction func didPressDoneButton(_ sender: UIButton) {

        showSpinner()
        if self.orderId == -1 {
            self.presenter.addOrder(order: newOrder)
        } else {
            if isAllFieldsFilled() {
                print("ORDER \(newOrder)")
               self.presenter.verifyOrder(order: newOrder, orderId: self.orderId)
            } else {

                hideSpinner()
                
                let alertError = UIAlertController(title: "TaskErrorTitle".localized(), message: "TaskErrorDescription".localized(), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK".localized(), style: .default) { (alert: UIAlertAction!) -> Void in
                }
                alertError.addAction(cancelAction)

                self.present(alertError, animated: true, completion: nil)
            }
        }
    }

    @IBAction func didPressCancelButton(_ sender: UIButton) {

        let alert = UIAlertController(title: "Please, enter the reason of return".localized(), message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            
        }

        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]

            let reason = textField?.text! ?? ""

            self.presenter.orderReturn(orderId: self.orderId, reason: reason)
        }))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didPressApproveButton(_ sender: UIButton) {
        self.presenter.orderApproval(orderId: self.orderId)
    }
    
    @IBAction func didPressChatButton(_ sender: Any) {
        
        self.presenter.navigateToChat(taskID: String(self.orderId))
        
    }
    
}

//MARK: - UITableViewDataSource
extension CreateTaskPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return newOrder.fields.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if newOrder.ordetType == .new {
                switch indexPath.row {
                case 0:
                    if let orderInfoCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderInfoTableViewCell, for: indexPath) {

                        orderInfoCell.newOrder = self.newOrder
                        orderInfoCell.setData()

                        return orderInfoCell
                    }
                case 1:
                    if let orderDateCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderDateTableViewCell, for: indexPath) {

                        orderDateCell.newOrder = self.newOrder
                        orderDateCell.setData()

                        return orderDateCell
                    }
                case 2:
                    if let orderDescriptionCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderDescriptionTableViewCell, for: indexPath) {

                        orderDescriptionCell.newOrder = self.newOrder
                        orderDescriptionCell.setData()

                        return orderDescriptionCell
                    }
                case 3:
                    if let orderFieldsCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderFieldsTableViewCell, for: indexPath) {

                        return orderFieldsCell
                    }
                default:
                    return UITableViewCell()
                }
            } else {
                switch indexPath.row {
                case 0:
                    if let orderInfoCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderInfoTableViewCell, for: indexPath) {

                        orderInfoCell.newOrder = self.newOrder
                        orderInfoCell.setData()

                        return orderInfoCell
                    }
                case 1:
                    if let orderDescriptionCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderDescriptionTableViewCell, for: indexPath) {

                        orderDescriptionCell.newOrder = self.newOrder
                        orderDescriptionCell.setData()

                        return orderDescriptionCell
                    }
                case 2:
                    if let orderMapCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderMapTableViewCell, for: indexPath) {

                        orderMapCell.newOrder = self.newOrder
                        orderMapCell.updateContentData()
                        return orderMapCell
                    }
                case 3:
                    if let orderFieldsCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderFieldsTableViewCell, for: indexPath) {

                        return orderFieldsCell
                    }
                default:
                    return UITableViewCell()
                }
            }
        } else {

            let field = newOrder.fields[indexPath.row]
            
            switch field.type.lowercased() {
            case "txt":
                if newOrder.ordetType == .new {
                    if let textCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.previewTextTableViewCell, for: indexPath) {

                        textCell.field = field
                        textCell.updateContentData()

                        return textCell
                    }
                } else {
                    if let textCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderTextTableViewCell, for: indexPath) {

                        textCell.field = field
                        textCell.isEditable = !newOrder.isMyOrder && orderId != -1
                        textCell.delegate = self
                        textCell.updateContentData()

                        return textCell
                    }
                }

            case "photo":

                if let photoCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.previewPhotoTableViewCell, for: indexPath) {

                    photoCell.field = field
                    photoCell.delegate = self
                    photoCell.isEditable = !newOrder.isMyOrder && orderId != -1 && orderStatus != 4 && orderStatus != 3
                    photoCell.updateContentData()

                    return photoCell
                }
            case "video":
                if let videoCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.previewVideoTableViewCell, for: indexPath) {

                    videoCell.field = field
                    videoCell.delegate = self
                    videoCell.isEditable = !newOrder.isMyOrder && orderId != -1 && orderStatus != 4 && orderStatus != 3
                    videoCell.updateContentData()

                    return videoCell
                }
            case "check":
                print("Check LOAD")
                if let checkCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderCheckTableViewCell, for: indexPath) {
                   
                   
                    checkCell.checkButton.tag = indexPath.row + 1000
                    checkCell.checkImageView.tag = indexPath.row + 2000
                    
                    
                    
                    checkCell.field = field
                    checkCell.isEditable = orderStatus != 3 && orderStatus != 4
                    checkCell.delegate = self
                    checkCell.updateContentData()
                    return checkCell
                }
            case "mark":
                print("Mark")
                if let markCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderMarkTableViewCell, for: indexPath) {
                    
                    
                    markCell.field = field
                    markCell.updateContentData()
                    markCell.isEditable = orderStatus != 3 && orderStatus != 4
                    markCell.delegate = self
                    return markCell
                }
            default:
                return UITableViewCell()
            }
        }

        return UITableViewCell()
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension CreateTaskPreviewViewController: CreateTaskPreviewControllerInput {
    func provideOrderData(success: Bool, order: NewOrder, error: [String : Any]?) {
        hideSpinner()
        if success {

            self.newOrder = order
            print("newOrder \(order.ordetType)")
            setupButtonsLayout()
//            if order.isMyOrder {
//                navTitleLabel.text = "My Orders".localized();
//            } else {
//                navTitleLabel.text = "In work".localized();
//            }
            setupProgressLabel(status: orderStatus)
            
            self.orderFieldsTableView.reloadData()
        }
    }
    
    private func setupProgressLabel(status: Int) {
        
        switch status {
        case 1: //CREATE
            self.navTitleLabel.text = "CREATE".localized()
        case 2: //ACCEPTED
            self.navTitleLabel.text = "ACTIVE".localized()
            
        case 3: //VERIFIED
            self.navTitleLabel.text = "DONE".localized()
           
        case 4: //APPROVE
            self.navTitleLabel.text = "APPROVE".localized()
        case 5: //RETURNED_TO_VERIFIER
            self.navTitleLabel.text = "RETURNED".localized()
           
        default:
            break
        }
    }

    func provideAddOrderResponse(success: Bool, errorTitle: String, errorMessage: String) {

        hideSpinner()
        if success {
            self.presenter.navigateToDashboard()
        } else {
            showAlert(title: errorTitle, message: errorMessage)
        }
    }

    func provideOrderVerifierResponse(success: Bool, errorTitle: String, errorMessage: String) {
        hideSpinner()
        if success {
            self.presenter.showVerifierPopUoView()
        } else {
            showAlert(title: errorTitle, message: errorMessage)
        }
    }

    func provideOrderApprovalResponse(success: Bool, errorTitle: String, errorMessage: String) {
        hideSpinner()
        if success {
            self.navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: errorTitle, message: errorMessage)
        }
    }

    func provideOrderReturnResponse(success: Bool, errorTitle: String, errorMessage: String) {
        hideSpinner()
        if success {
            self.navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: errorTitle, message: errorMessage)
        }
    }
}

extension CreateTaskPreviewViewController: OrderFieldProtocol {
    func addNewPhoto(field: Field) {
        self.selectedField = field
        self.presenter.showMediaActionSheet()
    }

    func addNewVideo(field: Field) {
        self.selectedField = field
        self.presenter.showChooseVideoActionSheet()
    }

    func addNewDescription(field: Field) {
        for (index, element) in newOrder.fields.enumerated() {
            if element.label == field.label {
                newOrder.fields[index] = field
            }
        }
        orderFieldsTableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func addNewCheck(field: Field) {
        for (index, element) in newOrder.fields.enumerated() {
            
            if element.label == field.label {
                newOrder.fields[index].data = field.data
            }
        }
    }
    
    func addNewMark(field: Field) {
        for (index, element) in newOrder.fields.enumerated() {
            
            if element.label == field.label {
                newOrder.fields[index] = field
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate
extension CreateTaskPreviewViewController: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.clearSelectedValue()
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.selectedField.photoArray.append(image)

            for (index, element) in newOrder.fields.enumerated() {
                if element.label == selectedField.label {
                    newOrder.fields[index] = selectedField
                }
            }
            orderFieldsTableView.reloadSections(IndexSet(integer: 1), with: .none)
        }

        if let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType.isEqual(kUTTypeMovie as String) {
            let videoPath = info[UIImagePickerControllerMediaURL] as? URL
            if let url = videoPath {
                setVideoToField(url: url)
            }
        }

        self.picker.dismiss(animated: true, completion: nil)
    }

    func setVideoToField(url: URL) {

        let data = try? Data(contentsOf: url, options: .dataReadingMapped)

        let asset = AVAsset(url: url)
        guard
            let dataImg = InternalHelper.sharedInstance.thumbnailForVideoAtURL(asset: asset), let dataVideo = data else { return }

        let mb = Double(Double(dataVideo.count) / Double(1024) / Double(1024))
        let second = InternalHelper.sharedInstance.getSecondFromVideo(asset: asset)

        switch (mb, second) {
        case (0...50, 0...60):
            self.selectedField.photoArray.removeAll()
            self.selectedField.photoArray.append(InternalHelper.sharedInstance.normalizedImage(img: dataImg))
            self.selectedField.videoData = dataVideo
            for (index, element) in newOrder.fields.enumerated() {
                if element.label == selectedField.label {
                    newOrder.fields[index] = selectedField
                }
            }

            self.orderFieldsTableView.reloadSections(IndexSet(integer: 1), with: .none)
        case (50..., _):
            self.showAlert(title: "Error".localized(), message: "The size of a video should not be bigger than 50 MB.".localized())
        case (_, 60...):
            self.showAlert(title: "Error".localized(), message: "A video should not last longer than 1 minute.".localized())
        default:
            self.showAlert(title: "Error".localized(), message: "A video should not last longer than 1 minute and be bigger than 50 MB.".localized())
        }
    }
}

//MARK: PopUpWindowProtocol
extension CreateTaskPreviewViewController: PopUpWindowProtocol {
    func didPressOKButton() {
        self.presenter.popUpDidPressOKButton()
    }

    func didPressHidePopUpButton() {
        self.presenter.popUpDidPressHidePopUpButton()
    }

    func didPressFacebookButton() {
    }

    func didPressTwitterButton() {
    }
}
