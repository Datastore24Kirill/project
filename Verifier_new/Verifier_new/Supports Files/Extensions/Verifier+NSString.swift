//
//  Verifier+NSString.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

extension String {
    func localized() ->String {
        
        var language = "ru"
        
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String {
            language = lang
        }
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func localized(param: String) -> String {
        

        return NSString.localizedStringWithFormat((self).localized() as NSString, param) as String
    }
    
}

