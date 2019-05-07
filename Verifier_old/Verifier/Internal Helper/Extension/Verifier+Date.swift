//
//  Verifier+Date.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 02.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
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
