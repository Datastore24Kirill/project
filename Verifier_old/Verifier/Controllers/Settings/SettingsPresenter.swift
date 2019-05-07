//
//  SettingsPresenter.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 23.04.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SettingsPresenterOutput: class {
 
}

class SettingsPresenter: SettingsViewControllerOutput, SettingsInteractorOutput {
    
    //MARK: Properties
    var router: SettingsRoutingInput!
    weak var view: SettingsViewControllerInput!
    var interactor: SettingsInteractorInput!
    
    func showShareActivity(with text: String) {
        router.showShareActivity(with: text)
    }
    
    func showPicker(for items: [String], selectedValue: String) {
        router.showPicker(for: items, selectedValue: selectedValue)
    }
    
    func getUserSettings() {
        interactor.getUserSettings()
    }
    
    func provideData(with result: ServerResponse<UserSettings>) {
        view.provideData(with: result)
    }
    
    func setUserWallet(with address: String) {
        interactor.setUserWallet(with: address)
    }
    
    func provideWalletAddressSettingData(result: ResponseResult) {
        view.provideWalletAddressSettingData(result: result)
    }
    
    func sendFeedBack(with subject: String, and text: String) {
        interactor.sendFeedBack(with: subject, and: text)
    }
    
    func provideFeedBackSendingData(result: ResponseResult) {
        view.provideFeedBackSendingData(result: result)
    }
}
