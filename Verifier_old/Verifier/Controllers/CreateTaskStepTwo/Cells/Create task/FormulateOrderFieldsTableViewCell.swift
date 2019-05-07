//
//  FormulateOrderFieldsTableViewCell.swift
//  Verifier
//
//  Created by Mac on 4/30/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FormulateOrderFieldsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addFieldLabel: UILabel!
    
    //MARK: - Properties
    var preparePressAddField = DelegetedManager<(())>()

    //MARK: - UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        localizeUIElement()
    }

    func localizeUIElement() {
        titleLabel.text = "Formulate the order fields".localized()
        descriptionLabel.text = "Complete your order by adding the fields that are necessary to complete the tasks".localized()
        addFieldLabel.text = "Add a field".localized()
    }
    
    //MARK: - Actions
    @IBAction func didPressAddFieldLabelButton(_ sender: UIButton) {
        preparePressAddField.callback?(())
    }
    
}
