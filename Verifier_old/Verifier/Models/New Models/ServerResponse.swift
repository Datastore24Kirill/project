//
//  ServerResponse.swift
//  Verifier
//
//  Created by Mac on 4/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

enum ServerResponse<T> {
    case success(T)
    case faild(alertText: AlertText)
    case serverError
    case noInternet
}
