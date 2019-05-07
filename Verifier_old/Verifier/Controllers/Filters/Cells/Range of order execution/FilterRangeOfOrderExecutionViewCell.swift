//
//  FilterRangeOfOrderExecutionViewCell.swift
//  Verifier
//
//  Created by Mac on 4/23/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FilterRangeOfOrderExecutionViewCell: UITableViewCell {

    //MARK: - typealies
    typealias TypeItem = FiltersViewController.TypePickerItem
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var choiceDateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    var openPickerView = DelegetedManager<(values: [String], title: String, type: TypeItem)>()
    var choiceDateTitle: String!
    
    private let values = [
        "Today".localized(),
        "Tomorrow".localized(),
        "Within 1 week".localized(),
        "Within 1 month".localized(),
        "All".localized()
    ]
    
    // MARK: - UITableViewCell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "Range of order execution".localized()
        descriptionLabel.text = "Period".localized()
    }
    
    //MARK: - Methods
    func updateTitle(with title: String) {
        choiceDateButton.setTitle(title, for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func didPressChoiceButton(_ sender: UIButton) {
        let title = "Choose a date".localized()
        openPickerView.callback?((values: values, title: title, type: .rangeOfOrderExecution))
    }
    
}
