//
//  OrderMarkTableViewCell.swift
//  Verifier
//
//  Created by Кирилл on 12/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import Cosmos

class OrderMarkTableViewCell: PreviewBaseTableViewCell {
  
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var markStars: CosmosView!
    
    var delegate: OrderFieldProtocol?
    
    var isEditable = true
    var field = Field()
    fileprivate let cellPadding: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //        localizeUIElement()
    }
    
    //    func localizeUIElement() {
    //        nameHintLabel.text = "Name of the field".localized()
    //    }
    

    override func updateContentData() {
        titleLabel.text = field.label
        print("MARKMARK \(field.data)")
        
        if !isEditable {
            markStars.isUserInteractionEnabled = false
        }
        
        if field.data.count != 0 {
            markStars.rating = Double(field.data) ?? 0
            
        }else{
            markStars.rating = 0.0
        }
        
        markStars.didFinishTouchingCosmos = { rating in
            print("RATING \(rating)")
           
            self.field.data.removeAll()
            self.field.data.append(String(Int(rating)))
            self.delegate?.addNewMark(field: self.field)
            
        }
        
    }
    
}
