//
//  Verifier+Date.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

extension Date {
    
    
    func getDateString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode!)
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
