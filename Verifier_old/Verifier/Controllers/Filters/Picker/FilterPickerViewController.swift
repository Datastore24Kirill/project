//
//  FilterPickerViewController.swift
//  Verifier
//
//  Created by Mac on 4/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol FilterPickerDataProtocol {
    func didCancelPickerData()
    func didChosePickerItem(value: String)
}

class FilterPickerViewController: UIViewController {
    
    //MARK: - Outletes
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    //MARK: - Properties
    var delegate: FilterPickerDataProtocol!
    var pickerDataList = [String]()
    
    var pickerTitel = ""
    var nameChoosedItem = ""

    //MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareText()
        prepareChoiceItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareChoiceItem()
    }
    
    //MARK: - Methods
    private func prepareText() {
        titleLabel.text = pickerTitel
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        doneButton.setTitle("Done".localized(), for: .normal)
    }
    
    func prepareChoiceItem() {
        
        guard let index = pickerDataList.index(of: nameChoosedItem) else {
            return
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
        
    }
    
    // MARK: - Actions
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        delegate?.didCancelPickerData()
    }
    
    @IBAction func didPressDoneButton(_ sender: UIButton) {
        if pickerDataList.count != 0 {
            let index = pickerView.selectedRow(inComponent: 0)
            let name = pickerDataList[index]
            delegate?.didChosePickerItem(value: name)
        }
    }

}

//MARK: - UIPickerViewDelegate
extension FilterPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataList[row]
    }
}

//MARK: - UIPickerViewDataSource
extension FilterPickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataList.count
    }
}
