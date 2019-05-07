//
//  Rounded + Double.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 21/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
