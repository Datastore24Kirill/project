//
//  AddNewPhotoCollectionViewCell.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class AddNewPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var takePhotoLabel: UILabel!
    
    var delegate: TaskPhotoCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        takePhotoLabel.text = "Take a Photo".localized()
    }
    
    @IBAction func didPressAddNewPhotoButton(_ sender: UIButton) {
        self.delegate?.addNewImage()
    }
}
