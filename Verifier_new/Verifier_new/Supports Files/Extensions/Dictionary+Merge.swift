//
//  Dictionary+Merge.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 11/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
