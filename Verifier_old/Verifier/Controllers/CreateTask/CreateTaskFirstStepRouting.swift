//
//  CreateTaskFirstStepRouting.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 01.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CreateTaskFirstStepRoutingInput: class {
    func showPicker(for items: [String], selectedValue: String)
    func showDatePicker(selectedDate: Date, pickerType: DatePickerType)
    
    func openSecondStage()
    func openMapSearch()
}

class CreateTaskFirstStepRouting: CreateTaskFirstStepRoutingInput, CreateTaskFirstStepPresenterOutput {

    //MARK: Properties
    weak var viewController: CreateTaskFirstStepViewController!
    
    func showPicker(for items: [String], selectedValue: String) {
        guard let controller = R.storyboard.other.verifierPickerVC() else { return }
        controller.delegate = viewController
        controller.pickerDataArray = items
        controller.selectedValue = selectedValue
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.navigationController?.present(controller, animated: false)
    }
    
    func showDatePicker(selectedDate: Date, pickerType: DatePickerType) {
        guard let controller = R.storyboard.other.datePickerVC() else { return }
        controller.delegate = viewController
        controller.selectedDate = selectedDate
        controller.pickerType = pickerType
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.navigationController?.present(controller, animated: false)
    }
    
    func openSecondStage() {
        guard let controller = R.storyboard.createTaskStepTwo.createTaskTwo() else { return }
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openMapSearch() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self.viewController.googleMapManager
        self.viewController.present(acController, animated: true, completion: nil)
    }
}
