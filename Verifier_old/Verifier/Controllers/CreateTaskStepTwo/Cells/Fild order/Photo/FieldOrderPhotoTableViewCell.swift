//
//  FieldOrderPhotoTableViewCell.swift
//  Verifier
//
//  Created by Mac on 5/2/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FieldOrderPhotoTableViewCell: FieldOrderDefaultTableViewCell {

    @IBOutlet weak var choosePhotosCountLabel: UILabel!
    @IBOutlet weak var photosCountButton: UIButton!

    //MARK: - Properties
    var preparePressPhotoCountButton = DelegetedManager<(Int)>()

    //MARK: - UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //"Select the number of photos"
        titleImageView.image = #imageLiteral(resourceName: "@photo_field_icon")
        choosePhotosCountLabel.text = "Select the number of photos".localized()
    }

    //MARK: - Methods
    func updatePhotoCountButtonIndex(with index: Int) {
        photosCountButton.tag = index
    }

    //MARK: - Actions
    @IBAction func nameChanged(_ sender: Any) {
        NewOrder.sharedInstance.fields[currentIndexPath.row].label = titleTextField.text!
    }
    
    @IBAction func didChoosePhotosCountAction(_ sender: UIButton) {
        let index = photosCountButton.tag
        preparePressPhotoCountButton.callback?(index)
    }
}
