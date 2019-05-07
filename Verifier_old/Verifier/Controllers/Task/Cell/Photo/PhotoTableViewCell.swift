//
//  PhotoTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 06.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var takePhotoLabel: UILabel!
    var parentVC: BaseDetailTaskViewController? = nil
    var takePhotoArray: [UIImage] = [UIImage]()
    
    var name = ""
    var labelText = "" {
        didSet { label.text = labelText }
    }

}


//MARK: UICollectionViewDelegate
extension PhotoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.takePhotoArray.count {
        case 0:
            return 1
        case 1:
            return 2
        case 2, 3:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < self.takePhotoArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.Indentifiers.taskPhotoCell.rawValue, for: indexPath) as! TaskPhotoCollectionViewCell
            cell.delegate = self
            cell.currentIndexPath = indexPath
            cell.updateContentData(image: self.takePhotoArray[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.Indentifiers.addNewPhotoCell.rawValue, for: indexPath) as! AddNewPhotoCollectionViewCell
            cell.takePhotoLabel.isHidden = self.takePhotoArray.count > 0 ? true : false
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.takePhotoArray.count == 0 {
            return CGSize(width: self.photoCollectionView.bounds.size.width, height: self.photoCollectionView.bounds.size.height)
        } else {
            return CGSize(width: (self.photoCollectionView.bounds.size.width - 20) / 3, height: self.photoCollectionView.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: TaskPhotoCellProtocol
extension PhotoTableViewCell: TaskPhotoCellProtocol {
    
    func addNewImage() {
        self.parentVC?.showChoosePhotoActionSheet(fieldName: name)
    }
    
    func deleteImageAtIndexPath(indexPath: IndexPath) {
        self.takePhotoArray.remove(at: indexPath.row)
        
        if let parVC = self.parentVC {
            for i in 0..<parVC.takePhotosArray.count {
                if parVC.takePhotosArray[i].fieldName == name {
                    parVC.takePhotosArray[i].array = self.takePhotoArray
                    parVC.dataTableView.reloadData()
                }
            }
        }
        
        
        //self.parentVC?.takePhotoArray = self.takePhotoArray
        self.parentVC?.dataTableView.reloadData()
    }
}
