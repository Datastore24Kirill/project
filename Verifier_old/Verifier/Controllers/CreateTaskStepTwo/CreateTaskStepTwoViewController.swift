//
//  CreateTaskStepTwoViewController.swift
//  Verifier
//
//  Created by Mac on 4/30/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class CreateTaskStepTwoViewController: VerifierAppDefaultViewController {

    //MARK: - Outlets
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var navSubTitleLabel: UILabel!
    @IBOutlet weak var createTaskTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Properties
    var orderValidStatus: OrderValidStatus = .noAnyItems
    let menuHeaderVC = R.storyboard.menuHeader.menuHeaderVC()
    var fieldList = [CreateTaskStepTwoTableModel]()
    let photosCountArray = ["1", "2", "3", "4", "5"]
    var currentPhotoIndex = 0
    
    //MARK: UIViewController lifycy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        createTaskTableView.register(R.nib.createTaskChooseFieldTableViewCell)
        createTaskTableView.register(R.nib.formulateOrderFieldsTableViewCell)
        createTaskTableView.register(R.nib.fieldOrderTextTableViewCell)
        createTaskTableView.register(R.nib.fieldOrderVideoTableViewCell)
        createTaskTableView.register(R.nib.fieldOrderPhotoTableViewCell)
        
        
        for field in NewOrder.sharedInstance.fields {
            if field.type.lowercased() == "txt" {
                fieldList.append(CreateTaskStepTwoTableModel(type: .text))
            } else if field.type.lowercased() == "photo" {
                fieldList.append(CreateTaskStepTwoTableModel(type: .photo))
                
            } else if field.type.lowercased() == "video" {
                fieldList.append(CreateTaskStepTwoTableModel(type: .video))
            }
        }
        
        fieldList.append(CreateTaskStepTwoTableModel(type: .add))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI
    func prepareUI() {
        navTitleLabel.text = "My Orders".localized()
        navSubTitleLabel.text = "Step 2".localized()
        
        nextButton.backgroundColor = UIColor.verifierBlueColor()
        //nextButton.layer.cornerRadius = 5.0
        nextButton.setTitle("Next".localized(), for: .normal)
    }

    //MARK: - Validation
    func isOrderValid() -> OrderValidStatus {
        if NewOrder.sharedInstance.fields.count == 0 {
            return .noAnyItems
        }

        for field in NewOrder.sharedInstance.fields {
            if field.label.count == 0 {
                return .notFilled
            }
        }

        return .isValid
    }

    //MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func showPicker(for items: [String], selectedValue: String) {
        guard let controller = R.storyboard.other.verifierPickerVC() else { return }
        controller.delegate = self
        controller.pickerDataArray = items
        controller.selectedValue = selectedValue
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.present(controller, animated: false)
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        switch isOrderValid() {
        case .isValid:
            guard let controller = R.storyboard.settings.createTaskPreviewVC() else { return }

            controller.newOrder = NewOrder.sharedInstance
            controller.orderStatus = -1
            self.navigationController?.pushViewController(controller, animated: true)
        case .noAnyItems:
            showAlert(title: "Error".localized(), message: "Complete your order by adding the fields that are necessary to complete the tasks".localized())
        case .notFilled:
            showAlert(title: "Error".localized(), message: "Fill out the fields of order to be verified".localized())
        }
    }
}

//MARK: - UITableViewDataSource
extension CreateTaskStepTwoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch fieldList[indexPath.row].type {
        case .add:
            if let formulateOrderFieldCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.formulateOrderFieldsTableViewCell, for: indexPath) {
                
                
                formulateOrderFieldCell.preparePressAddField.delegate(to: self) { (self, _) in
                    self.fieldList.removeLast()
                    self.fieldList.append(CreateTaskStepTwoTableModel(type: .choose))
                    
                    let index = IndexPath(item: self.fieldList.count-1, section: 0)
                    self.createTaskTableView.reloadRows(at: [index], with: .fade)
                }
                
                return formulateOrderFieldCell
            }
        case .choose:
            if let addCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.createTaskChooseFieldTableViewCell, for: indexPath) {
                
                addCell.clearBackground()
                addCell.preparePressAddField.delegate(to: self) { (self, type) in
                    
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {
                        let index = IndexPath(item: self.fieldList.count-1, section: 0)
                        self.createTaskTableView.scrollToRow(at: index, at: UITableViewScrollPosition.middle, animated: true)
                        
                    }
                    
                    switch type {
                    case .text:
                        NewOrder.sharedInstance.fields.append(Field(label: "", type: "txt", name: "", minCount: "", data: String(), photoArray: [], videoData: nil))
                    case .photo:
                        NewOrder.sharedInstance.fields.append(Field(label: "", type: "photo", name: "", minCount: "1", data: String(), photoArray: [], videoData: nil))

                    case .video:
                        NewOrder.sharedInstance.fields.append(Field(label: "", type: "video", name: "", minCount: "1", data: String(), photoArray: [], videoData: nil))
                    
                    default:
                        break
                    }
                    
                    self.fieldList[self.fieldList.count - 1] = CreateTaskStepTwoTableModel(type: .add)
                                    
                    let count = self.fieldList.count
                    self.fieldList.insert(CreateTaskStepTwoTableModel(type: type), at: count - 1)
                    
                    self.createTaskTableView.reloadData()
                    CATransaction.commit()
                }
                return addCell
            }
        case .text:
            if let fieldOrderText = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldOrderTextTableViewCell, for: indexPath) {
                fieldOrderText.currentIndexPath = indexPath
                fieldOrderText.updateIndex(with: indexPath.row)
                fieldOrderText.titleTextField.text = NewOrder.sharedInstance.fields[indexPath.row].label
                fieldOrderText.descriptionTextView.text = NewOrder.sharedInstance.fields[indexPath.row].name
                
                fieldOrderText.prepareDeleteOrder.delegate(to: self) { (self, index) in
                    self.fieldList.remove(at: index)
                    NewOrder.sharedInstance.fields.remove(at: index)
                    self.createTaskTableView.reloadData()
                }
                
                return fieldOrderText
            }
            
        
            
        case .video:
            
            if let fieldOrderText = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldOrderVideoTableViewCell, for: indexPath) {
                fieldOrderText.currentIndexPath = indexPath
                fieldOrderText.updateIndex(with: indexPath.row)
                fieldOrderText.titleTextField.text = NewOrder.sharedInstance.fields[indexPath.row].label
                fieldOrderText.descriptionTextView.text = NewOrder.sharedInstance.fields[indexPath.row].name
                
                fieldOrderText.prepareDeleteOrder.delegate(to: self) { (self, index) in
                    self.fieldList.remove(at: index)
                    NewOrder.sharedInstance.fields.remove(at: index)
                    self.createTaskTableView.reloadData()
                }
                
                return fieldOrderText
            }
            
        case .photo:
            if let fieldOrderPhoto = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldOrderPhotoTableViewCell, for: indexPath) {
                fieldOrderPhoto.currentIndexPath = indexPath
                fieldOrderPhoto.updateIndex(with: indexPath.row)
                fieldOrderPhoto.titleTextField.text = NewOrder.sharedInstance.fields[indexPath.row].label
                fieldOrderPhoto.descriptionTextView.text = NewOrder.sharedInstance.fields[indexPath.row].name

                let minCount = NewOrder.sharedInstance.fields[indexPath.row].minCount

                if minCount == "" {
                    fieldOrderPhoto.photosCountButton.setTitle(photosCountArray[0], for: .normal)
                } else {
                    fieldOrderPhoto.photosCountButton.setTitle(NewOrder.sharedInstance.fields[indexPath.row].minCount, for: .normal)
                }

                fieldOrderPhoto.preparePressPhotoCountButton.delegate(to: self) { (self, index) in
                    self.currentPhotoIndex = index

                    var selectedValue = self.photosCountArray[0]
                    if fieldOrderPhoto.photosCountButton.titleLabel?.text != nil {
                        selectedValue = (fieldOrderPhoto.photosCountButton.titleLabel?.text)!
                    }

                    self.showPicker(for: self.photosCountArray, selectedValue: selectedValue)
                }

                fieldOrderPhoto.updatePhotoCountButtonIndex(with: indexPath.row)

                fieldOrderPhoto.prepareDeleteOrder.delegate(to: self) { (self, index) in
                    self.fieldList.remove(at: index)
                    NewOrder.sharedInstance.fields.remove(at: index)
                    self.createTaskTableView.reloadData()
                }
                
                return fieldOrderPhoto
            }
        }
        
        return UITableViewCell()
    }
    
}

//MARK: - UITableViewDelegate
extension CreateTaskStepTwoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch fieldList[indexPath.row].type {
        case .add:
            return 250
        case .text, .video:
            return 370
        case .photo:
            return 400
        case .choose:
            return 380
        }
        
    }
}

extension CreateTaskStepTwoViewController: VerifierPickerProtocol {
    func closePicker(picker: UIViewController) {
        picker.dismiss(animated: false, completion: nil)
    }

    func selectValue(in array: [String], for index: Int, picker: UIViewController) {
        picker.dismiss(animated: false) {

        NewOrder.sharedInstance.fields[self.currentPhotoIndex].minCount = array[index]

            if let cell = self.createTaskTableView.cellForRow(at: IndexPath(item: self.currentPhotoIndex, section: 0)) as? FieldOrderPhotoTableViewCell {
                cell.photosCountButton.setTitle(array[index], for: .normal)
            }
        }
    }
}
