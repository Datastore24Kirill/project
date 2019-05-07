//
//  ResponseBody.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

struct ResponseBody<T: Decodable>: Decodable {
    var statusCode: Int
    var message: String
    var data: T?
    var code: String?
}
