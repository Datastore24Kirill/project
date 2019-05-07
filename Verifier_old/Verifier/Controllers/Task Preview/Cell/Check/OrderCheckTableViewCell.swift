//
//  CheckTableViewCell.swift
//  Verifier
//
//  Created by Кирилл on 12/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import SDWebImage

class OrderCheckTableViewCell: PreviewBaseTableViewCell {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    
    var delegate: OrderFieldProtocol?
    var isEditable = true
    
    
    var field = Field()
    fileprivate let cellPadding: CGFloat = 8.0
    
    
    func sendCheck(check: Bool) {
        field.data.removeAll()
        let isCheck = check ? "true" : "false"
        field.data = isCheck
        delegate?.addNewCheck(field: field)
        print(field)
    }
    
    
//    func localizeUIElement() {
//        nameHintLabel.text = "Name of the field".localized()
//    }
    
    override func updateContentData() {
        
        
        
        titleLabel.text = field.label
        desLabel.text = field.name
        checkButton.addTarget(self, action:  #selector(OrderCheckTableViewCell.checkAction(_:)), for: .touchUpInside)
        
        if field.data == "" {
            checkImageView.image = R.image.checkOff()
            sendCheck(check: false)
        } else if field.data == "true" {
            checkImageView.image = R.image.checkOn()
         } else if field.data == "false" {
            checkImageView.image = R.image.checkOff()
        }
        
        
    }
    
    
    @objc func checkAction(_ sender: UIButton) {
        let buttonTag = sender.tag
        print("sender.tag = \(buttonTag) and button.tag \(checkButton.tag)")
        
        if checkButton.tag == buttonTag {
            
            if let imageView = self.viewWithTag(buttonTag+1000) as? UIImageView {
                
                
                if imageView.image == R.image.checkOn()  {
                    print("UnChecked")
                    imageView.image = R.image.checkOff()
                    sendCheck(check: false)
                } else {
                    print("Checked")
                    imageView.image = R.image.checkOn()
                    sendCheck(check: true)

                }
            }
            
        }
        

        
    }
    
    
    

}
