//
//  CreateTaskChooseFieldTableViewCell.swift
//  Verifier
//
//  Created by Mac on 4/30/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class CreateTaskChooseFieldTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var chooseItemLabel: UILabel!

    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    
    @IBOutlet weak var textBagroundView: UIView!
    @IBOutlet weak var photoBagroundView: UIView!
    @IBOutlet weak var videoBagroundView: UIView!
    
    //MARK: - Properties
    typealias TypeField = CreateTaskStepTwoTableModel.TypeField
    var preparePressAddField = DelegetedManager<((TypeField))>()

    //MARK: - UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        localizeUIElement()
    }
    
    //MARK: - Methods
    func localizeUIElement() {
        chooseItemLabel.text = "Select additional means your order to be confirmed".localized()
        txtLabel.text = "Confirm by text".localized()
        photoLabel.text = "Confirm by photos".localized()
        videoLabel.text = "Confirm by video".localized()
    }

    func clearBackground() {
        textBagroundView.backgroundColor = .white
        photoBagroundView.backgroundColor = .white
        videoBagroundView.backgroundColor = .white
    }
    
    //MARK: - Actions
    @IBAction func didPressTextButton(_ sender: UIButton) {
        textBagroundView.backgroundColor = #colorLiteral(red: 0.9570000172, green: 0.9570000172, blue: 1, alpha: 1)
        preparePressAddField.callback?(.text)
    }
    
    @IBAction func didPressPhotoButton(_ sender: UIButton) {
        photoBagroundView.backgroundColor = #colorLiteral(red: 0.9570000172, green: 0.9570000172, blue: 1, alpha: 1)
        preparePressAddField.callback?(.photo)
    }
    
    @IBAction func didPressVideoButton(_ sender: UIButton) {
        videoBagroundView.backgroundColor = #colorLiteral(red: 0.9570000172, green: 0.9570000172, blue: 1, alpha: 1)
        preparePressAddField.callback?(.video)
    }
    
    
}
