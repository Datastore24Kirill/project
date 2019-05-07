//
//  SettingsInteractor.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 23.04.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import Foundation

protocol SettingsInteractorInput: class {
    func getUserSettings()
    func setUserWallet(with address: String)
    func sendFeedBack(with subject: String, and text: String)
}

protocol SettingsInteractorOutput: class {
    func provideData(with result: ServerResponse<UserSettings>)
    func provideWalletAddressSettingData(result: ResponseResult)
    func provideFeedBackSendingData(result: ResponseResult)
}

class SettingsInteractor: SettingsInteractorInput {
    
    //MARK: Properties
    weak var presenter: SettingsInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func getUserSettings() {
        apiRequestManager.getUserSettings { [weak self] result in
            self?.presenter.provideData(with: result)
        }
    }
    
    func setUserWallet(with address: String) {
        apiRequestManager.setUserWalletAddress(address: address) { [weak self] (result, respResult) in
            self?.presenter.provideWalletAddressSettingData(result: respResult)
        }
    }
    
    func sendFeedBack(with subject: String, and text: String) {
        apiRequestManager.sendFeedBack(subject: subject, text: text) { [weak self] (result, respResult) in
            self?.presenter.provideFeedBackSendingData(result: respResult)
        }
    }
    
}
