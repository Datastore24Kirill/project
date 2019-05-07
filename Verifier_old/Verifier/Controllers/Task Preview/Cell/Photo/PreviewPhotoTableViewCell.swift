//
//  PreviewPhotoTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 08.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import SDWebImage

class PreviewPhotoTableViewCell: PreviewBaseTableViewCell {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var photoCollectionViewHeightConstraint: NSLayoutConstraint!

    var field = Field()
    var delegate: OrderFieldProtocol?
    var isEditable = false
    let minCount = 1
    fileprivate let cellPadding: CGFloat = 8.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoCollectionView.register(R.nib.photoCollectionViewCell(), forCellWithReuseIdentifier: R.reuseIdentifier.photoCollectionViewCell.identifier)

        localizeUIElement()
    }

    func localizeUIElement() {
       
    }

    override func updateContentData() {

        print("PHOTOFIELD \(field)")
        if isEditable {
            bottomInfoLabel.text = "Fill out the fields of order to be verified".localized()
            bottomInfoLabelHeightConstraint.constant = 60
        } else {
            bottomInfoLabel.text = ""
            bottomInfoLabelHeightConstraint.constant = 30
        }

        layoutIfNeeded()

        nameLabel.text = field.label
        descriptionLabel.text = field.name

        photoCollectionView.reloadData()

        
        photoCollectionViewHeightConstraint.constant = photoCollectionView.collectionViewLayout.collectionViewContentSize.height
       
//        photoCollectionViewHeightConstraint.constant = photoCollectionView.bounds.size.width + cellPadding
           
    }
}

//MARK: - UICollectionViewDataSource
extension PreviewPhotoTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return minCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.photoCollectionViewCell, for: indexPath) {

            if isEditable {
                if field.photoArray.count - 1 >= indexPath.row {

                    if let photo = field.photoArray[indexPath.row] {
                        cell.fieldPlaceholderView.isHidden = true
                        cell.fieldImageView.isHidden = false
                        cell.fieldImageView.image = photo
                    } else {
                        cell.fieldPlaceholderView.isHidden = false
                        cell.fieldImageView.isHidden = true
                        cell.fieldImageView.image = nil
                    }
                }

            } else {

                if field.photoArray.count - 1 >= indexPath.row, let photo = field.photoArray[indexPath.row] {

                    cell.fieldPlaceholderView.isHidden = true
                    cell.fieldImageView.isHidden = false
                    cell.fieldImageView.image = photo

                } else {
                    if field.data.count > 0 {
                        cell.fieldPlaceholderView.isHidden = true
                        cell.fieldImageView.image = nil
                        cell.fieldImageView.isHidden = false
                        cell.fieldImageView.sd_setImage(with: URL(string: field.data), placeholderImage: nil)

                    } else {
                        cell.fieldPlaceholderView.isHidden = false
                        cell.fieldImageView.isHidden = true
                        cell.fieldImageView.image = nil
                    }
                }
            }

            return cell
        }

        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegate
extension PreviewPhotoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: photoCollectionView.bounds.size.width - cellPadding, height: 222)
            
    }
}

//MARK: - UICollectionViewDelegate
extension PreviewPhotoTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditable {
            self.delegate?.addNewPhoto(field: field)
        }
    }
}
