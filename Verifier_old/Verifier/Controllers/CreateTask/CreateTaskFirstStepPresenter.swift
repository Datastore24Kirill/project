//
//  CreateTaskFirstStepPresenter.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 01.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol CreateTaskFirstStepPresenterOutput: class {
    
}

class CreateTaskFirstStepPresenter: CreateTaskFirstStepViewControllerOutput, CreateTaskFirstStepInteractorOutput {

    //MARK: Properties
    var router: CreateTaskFirstStepRoutingInput!
    weak var view: CreateTaskFirstStepViewControllerInput!
    var interactor: CreateTaskFirstStepInteractorInput!
    
    func showPicker(for items: [String], selectedValue: String) {
        router.showPicker(for: items, selectedValue: selectedValue)
    }
    
    func showDatePicker(selectedDate: Date, pickerType: DatePickerType) {
        router.showDatePicker(selectedDate: selectedDate, pickerType: pickerType)
    }
    
    func getContentList() {
        interactor.getContentList()
    }
    
    func provideContentListData(result: ServerResponse<[FilterContentModel]>) {
        view.provideContentListData(result: result)
    }
    
    func openSecondStage() {
        router.openSecondStage()
    }
    
    func openMapSearch() {
        router.openMapSearch()
    }
}
