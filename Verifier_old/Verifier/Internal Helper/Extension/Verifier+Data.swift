//
//  Verifier+Data.swift
//  Verifier
//
//  Created by Mac on 03.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)
        
        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = ".jpg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        default:
            ext = ".png"
        }
        return ext
    } 
}
