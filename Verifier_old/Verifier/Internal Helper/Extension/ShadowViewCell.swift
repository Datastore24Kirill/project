//
//  ShadowViewCell.swift
//  Verifier
//
//  Created by Mac on 06.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import UIKit

class ShadowViewCell: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        
        self.layer.shadowColor = UIColor.verifierShadowPinkColor().cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 20)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
