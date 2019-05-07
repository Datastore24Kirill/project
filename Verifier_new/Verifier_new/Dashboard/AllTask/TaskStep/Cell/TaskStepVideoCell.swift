//
//  TaskStepVideoCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import MobileCoreServices

class  TaskStepVideoCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoImageView: verifierUIImageView!
    @IBOutlet weak var takeVideoButton: verifierUIButton!
    
    //MARK: - VARIABLES
    var indexPath:  IndexPath?
    var section:    Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoView.layer.cornerRadius = 5
        videoView.layer.borderColor = UIColor.lightGray.cgColor
        videoView.layer.borderWidth = 1
        videoView.clipsToBounds = true
    }
    
    func setupUI(stepField: StepField, indexPath: IndexPath?, section: Int?) {
        descriptionLabel.text           = (stepField.fieldName ?? "") + "\n\n" + (stepField.fieldDescription ?? "")
        videoImageView.fieldId          = stepField.fieldId
        videoImageView.fieldRequired    = stepField.fieldRequired
        takeVideoButton.alpha           = 1
        if let _ = stepField.answerVideoLink {
            takeVideoButton.setTitle(nil, for: .normal)
        }
        else {
            takeVideoButton.setTitle("сделать видео".uppercased(), for: .normal)
        }
        requiredLabel.alpha             = stepField.fieldRequired ? 1 : 0
        takeVideoButton.setTitleColor(UIColor.black, for: .normal)
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
