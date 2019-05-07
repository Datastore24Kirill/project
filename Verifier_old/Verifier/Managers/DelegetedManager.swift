//
//  DelegetedManager.swift
//  Verifier
//
//  Created by Mac on 4/28/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct DelegetedManager<Input> {
    private(set) var callback: ((Input) -> ())?
    
    mutating func delegate<Object: AnyObject>(to object: Object, with callback: @escaping(Object, Input) -> ()) {
        self.callback = { [weak object] input in
            guard let object = object else { return }
            callback(object, input)
        }
    }
}
