//
//  ResponseResult.swift
//  Verifier
//
//  Created by Mac on 05.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

enum ResponseResult {
    case none, noInternet, serverError(String), success, failed(String)
}
