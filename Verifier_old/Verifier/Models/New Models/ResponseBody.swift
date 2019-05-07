//
//  ResponseBody.swift
//  Verifier
//
//  Created by Mac on 4/26/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct ResponseBody<T: Decodable>: Decodable {
    var statusCode: Int
    var message: String
    var data: T?
}
