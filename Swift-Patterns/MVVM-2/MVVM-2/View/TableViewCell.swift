//
//  TableViewCell.swift
//  MVVM-2
//
//  Created by Кирилл Ковыршин on 13/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            fullNameLabel.text = viewModel.fullName
            ageLabel.text = viewModel.age
        }
    }

}
