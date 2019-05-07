//
//  PreviewVideoTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 08.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import SDWebImage

class PreviewVideoTableViewCell: PreviewBaseTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var field = Field()
    var delegate: OrderFieldProtocol?
    var isEditable = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        collectionView.register(R.nib.photoCollectionViewCell(), forCellWithReuseIdentifier: R.reuseIdentifier.photoCollectionViewCell.identifier)

        localizeUIElement()
    }

    func localizeUIElement() {
        
    }

    override func updateContentData() {

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

        if field.photoArray.count == 0 {
            field.photoArray = [UIImage?](repeating: nil, count: 1)
        }

        setupCollectionLayout()
    }

    func setupCollectionLayout() {
        collectionView.reloadData()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height

        setNeedsLayout()
        layoutIfNeeded()
    }
}

//MARK: - UICollectionViewDataSource
extension PreviewVideoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 1
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
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewSize = collectionView.frame.size.width

        return CGSize(width: collectionViewSize, height: 222)
    }
}

//MARK: - UICollectionViewDelegate
extension PreviewVideoTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditable {
            self.delegate?.addNewVideo(field: field)
        }
    }
}
