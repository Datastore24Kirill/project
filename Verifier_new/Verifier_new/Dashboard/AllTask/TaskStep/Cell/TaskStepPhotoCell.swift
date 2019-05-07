//
//  TaskStepPhotoCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class  TaskStepPhotoCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var takePhotoButton: verifierUIButton!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var photoImageView: verifierUIImageView!
    @IBOutlet weak var photoView: UIView!
    
    //MARK: - VARIABLES
    var indexPath:  IndexPath?
    var section:    Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.layer.cornerRadius = 5
        photoView.layer.borderColor = UIColor.lightGray.cgColor
        photoView.layer.borderWidth = 1
        photoView.clipsToBounds = true
    }
    
    func setupUI(stepField: StepField, indexPath: IndexPath?, section: Int?) {
        descriptionLabel.text = (stepField.fieldName ?? "") + "\n\n" + (stepField.fieldDescription ?? "")
        photoImageView.fieldId = stepField.fieldId
        photoImageView.fieldRequired = stepField.fieldRequired
        takePhotoButton.alpha = 1
        if let _ = stepField.answerImageLink {
            takePhotoButton.setTitle(nil, for: .normal)
        }
        else {
            takePhotoButton.setTitle("сделать фото".uppercased(), for: .normal)
        }
        photoImageView.image = stepField.answerImage
        takePhotoButton.setTitleColor(UIColor.black, for: .normal)
        requiredLabel.alpha = stepField.fieldRequired ? 1 : 0
        if let IP = indexPath {
            self.indexPath = IP
            self.section = nil
        }
        else {
            self.indexPath = nil
            self.section = section
        }
    }
    
}
