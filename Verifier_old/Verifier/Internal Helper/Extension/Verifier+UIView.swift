//
//  Verifier+UIView.swift
//  Verifier
//
//  Created by Mac on 27.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    func setBlackGradient(view: UIView, isEnable: Bool = true) {
        
        if let sublayers = view.layer.sublayers {
            for layer in sublayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        var startBlackColor = UIColor(red: 66.0/255.0, green: 70.0/255.0, blue: 83.0/255.0, alpha: alpha).cgColor
        var endBlackColor = UIColor(red: 40.0/255.0, green: 42.0/255.0, blue: 49.0/255.0, alpha: alpha).cgColor
        
        if !isEnable {
            startBlackColor = UIColor(red: 189.0/255.0, green: 192.0/255.0, blue: 208.0/255.0, alpha: alpha).cgColor
            endBlackColor = UIColor.gray.cgColor
        }
        
        gradient.colors = [startBlackColor, endBlackColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.4, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.3)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.cornerRadius = view.cornerRadius
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setBlackGradient(view: UIView, width: CGFloat) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let startBlackColor = UIColor(red: 66.0/255.0, green: 70.0/255.0, blue: 83.0/255.0, alpha: 1.0).cgColor
        let endBlackColor = UIColor(red: 40.0/255.0, green: 42.0/255.0, blue: 49.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [startBlackColor, endBlackColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.4, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.3)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: width, height: view.frame.size.height)
        gradient.cornerRadius = view.cornerRadius
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func copyView() -> AnyObject{
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as AnyObject
    }
}
