//
//  Verifier+NSString.swift
//  Verifier
//
//  Created by iPeople on 02.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

extension String {
    func localized() ->String {

        var language = "en"

        if let lang = UserDefaults.standard.value(forKey: "lang") as? String {
            language = lang
        }

        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
