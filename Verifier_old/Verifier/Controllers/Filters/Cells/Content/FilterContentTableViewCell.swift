//
//  FilterThirdTableViewCell.swift
//  Verifier
//
//  Created by Mac on 4/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FilterContentTableViewCell: UITableViewCell {
    
    //MARK: - typealies
    typealias TypeItem = FiltersViewController.TypePickerItem
    
    //MARK: - Outlets
    @IBOutlet weak var choiceDateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var choiceDataLabel: UILabel!
    
    //MARK: - Properties
    var openPickerView = DelegetedManager<(values: [String], title: String, type: TypeItem)>()
    var values = [FilterContentModel]()

    //MARK: - UITableViewCell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = "".localized()
    }
    
    //MARK: - Methods
    func updateTitle(with title: String) {
        choiceDataLabel.text = title
    }
    
    //MARK: - Actions
    @IBAction func didPressChoiceButton(_ sender: UIButton) {
        let title = "Choose a content".localized()
        let stringValues = values.map { $0.description }
        openPickerView.callback?((values: stringValues, title: title, type: .byContents))
    }
    
}
