//
//  Task.swift
//  Verifier
//
//  Created by Mac on 02.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct Task {
    
    var id = 0
    var title = ""
    var text = ""
    var status = 0
    var city = ""
    var tokens = 0.0
    var rating = 0
    var verifAddrLongitude = 0.0
    var verifAddrLatitude = 0.0
    var fileds = [Field]()
}
