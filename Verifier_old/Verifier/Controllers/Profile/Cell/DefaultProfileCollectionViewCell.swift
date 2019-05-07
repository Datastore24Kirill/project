//
//  DefaultProfileCollectionViewCell.swift
//  Verifier
//
//  Created by Mac on 16.02.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class DefaultProfileCollectionViewCell: UICollectionViewCell {
    var delegate: ProfileProtocol?
    func reload() {}
}

extension DefaultProfileCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
