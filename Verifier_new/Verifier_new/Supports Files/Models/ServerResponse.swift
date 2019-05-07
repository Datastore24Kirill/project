//
//  ServerResponse.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

enum ServerResponse<T> {
    case success(T)
    case faild(alertText: AlertText)
    case serverError
    case noInternet
}
