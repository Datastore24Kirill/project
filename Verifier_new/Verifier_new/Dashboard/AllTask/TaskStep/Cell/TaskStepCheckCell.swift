//
//  TaskStepCheckCell.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class  TaskStepCheckCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segmentedControl: verifierUISegmentedControl!
    @IBOutlet weak var requiredLabel: UILabel!
    
    //MARK: - VARIABLES
    private var indexPath: IndexPath?
    private var section: Int?
    private var isAnswerYes: Bool?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
    
    func setupUI(stepField: StepField, indexPath: IndexPath?, section: Int?, answerYes: Bool?) {
        descriptionLabel.text           = (stepField.fieldName ?? "") + "\n\n" + (stepField.fieldDescription ?? "")
        segmentedControl.fieldId        = stepField.fieldId
        segmentedControl.fieldRequired  = stepField.fieldRequired
        segmentedControl.isAnswerYes    = answerYes
        if let IP = indexPath {
            segmentedControl.indexPath = IP
            segmentedControl.section = nil
        }
        else {
            segmentedControl.indexPath = nil
            segmentedControl.section = section
        }
        
        requiredLabel.alpha             = stepField.fieldRequired ? 1 : 0
//        segmentedControl.fieldUnderNo   = stepf
//        segmentedControl.fieldUnderYes = dict?["fieldUnderYes"] as? [[String : Any]]
//        segmentedControl.fieldIndexPath = indexPath
        segmentedControl.selectedSegmentIndex = 1
        if stepField.isAnswerYes == nil {
            segmentedControl.selectedSegmentIndex = 1
        }
        else {
            if stepField.isAnswerYes! {
                segmentedControl.selectedSegmentIndex = 0
            }
            else {
                segmentedControl.selectedSegmentIndex = 2
            }
        }
    }
}
