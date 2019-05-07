//
//  SendedDialogueView.swift
//  RoadHunter
//
//  Created by Mac on 11.10.17.
//  Copyright © 2017 Yatseyko Yura. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            config()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            config()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
                config()
            } else {
                layer.shadowColor = nil
                config()
            }
        }
    }
    
    func config() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
    
}
