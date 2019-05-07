//
//  FilterRadiusTableViewCell.swift
//  Verifier
//
//  Created by Mac on 4/24/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FilterRadiusTableViewCell: UITableViewCell {
    
    //MARK: - typealies
    typealias TypeItem = FiltersViewController.TypePickerItem
    
    //MARK: - Outlets
    @IBOutlet weak var choiceDateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    var openPickerView = DelegetedManager<(values: [String], title: String, type: TypeItem)>()
    var radiusTitle: String!
    var values = [String]()
    
    // MARK: - UIViewController Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = "Radius filter".localized()
    }
    
    //MARK: - Methods
    func updateTitle(with title: String) {
        choiceDateButton.setTitle(title, for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func didPressChoiceButton(_ sender: UIButton) {
        let title = "Choose a radius".localized()
        openPickerView.callback?((values: values, title: title, type: .byRadius))
    }
    
}
