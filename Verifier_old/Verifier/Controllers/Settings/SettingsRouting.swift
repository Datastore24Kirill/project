//
//  SettingsRouting.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 23.04.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol SettingsRoutingInput: class {
    func showShareActivity(with text: String)
    func showPicker(for items: [String], selectedValue: String)
}

class SettingsRouting: SettingsRoutingInput, SettingsPresenterOutput {
    
    //MARK: Properties
    weak var viewController: SettingsViewController!
    
    func showShareActivity(with text: String) {
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        viewController.present(vc, animated: true)
    }
    
    func showPicker(for items: [String], selectedValue: String) {
        
        guard let controller = R.storyboard.other.verifierPickerVC() else { return }
        controller.delegate = viewController
        controller.pickerDataArray = items
        controller.selectedValue = selectedValue
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.navigationController?.present(controller, animated: false)
    }
}
