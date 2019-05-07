//
//  GradientButton.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

import UIKit

class GradientButton: UIButton {
    
    @IBInspectable var violetButton:  Bool =  false { didSet { updateBacgroudGardient() }}
    
    func updateBacgroudGardient() {
        
        self.layer.cornerRadius = 8.0
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        if violetButton {
            
            let startColor = UIColor(red: 64.0/255.0, green: 115.0/255.0, blue: 213.0/255.0, alpha: 1.0).cgColor
            let endColor = UIColor(red: 100.0/255.0, green: 102.0/255.0, blue: 225.0/255.0, alpha: 1.0).cgColor
            
            gradient.colors = [startColor, endColor]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        } else {
            
            let startColor = UIColor(red: 66.0/255.0, green: 70.0/255.0, blue: 83.0/255.0, alpha: 1.0).cgColor
            let endColor =  UIColor(red: 40.0/255.0, green: 42.0/255.0, blue: 49.0/255.0, alpha: 1.0).cgColor
            
            gradient.colors = [startColor, endColor]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        gradient.cornerRadius = self.cornerRadius
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
}
