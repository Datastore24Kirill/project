//
//  TaskPhotoCollectionViewCell.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class TaskPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskPhotoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var ovalView: UIView!
    
    var delegate: TaskPhotoCellProtocol?
    var currentIndexPath: IndexPath = IndexPath()
    
    func updateContentData(image: UIImage) {
        
        self.taskPhotoImageView.layer.cornerRadius = 6.0
        self.taskPhotoImageView.image = image
    }
    
    @IBAction func didPressDeleteButton(_ sender: UIButton) {
        self.delegate?.deleteImageAtIndexPath(indexPath: self.currentIndexPath)
    }
}
