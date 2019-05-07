//
//  TaskStepMarkCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import Cosmos

class  TaskStepMarkCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cosmosView: verifierCosmosView!
    @IBOutlet weak var requiredLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupUI(stepField: StepField, indexPath: IndexPath?, section: Int?) {
        descriptionLabel.text           = (stepField.fieldName ?? "") + "\n\n" + (stepField.fieldDescription ?? "")
        requiredLabel.alpha             = stepField.fieldRequired ? 1 : 0
        cosmosView.fieldRequired        = stepField.fieldRequired
        cosmosView.rating               = stepField.answerMark ?? 0
        if let IP = indexPath {
            cosmosView.indexPath = IP
            cosmosView.section = nil
        }
        else {
            cosmosView.indexPath = nil
            cosmosView.section = section
        }
    }
    
}
