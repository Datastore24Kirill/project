//
//  VideoTableViewCell.swift
//  Verifier
//
//  Created by Mac on 15.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var showVideoView: UIView!
    @IBOutlet weak var showTakeVideoView: UIView!
    @IBOutlet weak var taskPhotoImageView: UIImageView!
    @IBOutlet weak var takeVideoLabel: UILabel!
    
    var parentVC: BaseDetailTaskViewController? = nil
    
    var currentPhoto: UIImage? {
        didSet {
            taskPhotoImageView.image = currentPhoto
            //taskPhotoImageView.transform = taskPhotoImageView.transform.rotated(by: CGFloat(M_PI_2))
            if currentPhoto != nil {
                self.showVideoView.isHidden = false
                self.showTakeVideoView.isHidden = true
            }
        }
    }
    
    var name = ""
    var labelText = "" {
        didSet { label.text = labelText }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        takeVideoLabel.text = "Record a Video".localized()
    }
    
    @IBAction func didPressTakeVideo(_ sender: UIButton) {
        self.parentVC?.showChooseVideoActionSheet(fieldName: name)
    }
    
    @IBAction func didPressDeleteVideo(_ sender: UIButton) {
        currentPhoto = nil
        DispatchQueue.main.async {
            if let index = self.parentVC?.takeVideosArray.enumerated().first(where: { $0.element.fieldName == self.name }).map({ $0.offset }) {
                self.parentVC?.takeVideosArray[index].data = nil
                self.parentVC?.takeVideosArray[index].photo = nil
                self.parentVC?.dataTableView.reloadData()
                self.showVideoView.isHidden = true
                self.showTakeVideoView.isHidden = false
            }
        }
    }
}
