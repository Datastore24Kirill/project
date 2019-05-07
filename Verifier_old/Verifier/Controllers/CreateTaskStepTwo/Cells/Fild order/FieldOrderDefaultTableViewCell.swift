
//  FieldOrderDefaultTableViewCell.swift
//  Verifier
//
//  Created by Mac on 5/2/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FieldOrderDefaultTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var titleHeaderLabel: UILabel!
    @IBOutlet weak var titleTypeLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteOrderButton: UIButton!
    
    //MARK: - Properties
    var prepareDeleteOrder = DelegetedManager<(Int)>()
    
    var currentIndexPath: IndexPath = IndexPath()

    //MARK: - UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleHeaderLabel.text = "Field of the order".localized()
        titleTypeLabel.text = "Type of the order".localized()
        titleNameLabel.text = "Name of the field".localized()
        descriptionLabel.text = "Describe shortly what is necessary".localized()
        descriptionTextView.textColor = UIColor.black
        
    }
    
    //MARK: - Methods
    func updateIndex(with index: Int) {
        deleteOrderButton.tag = index
    }
    
    //MARK: - Actions
    @IBAction func didPressdeleteOrderButton(_ sender: UIButton) {
        let index = deleteOrderButton.tag
        prepareDeleteOrder.callback?(index)
    }
}

//MARK: - UITextViewDelegate
extension FieldOrderDefaultTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        NewOrder.sharedInstance.fields[currentIndexPath.row].name = textView.text
    }
}
