//
//  SingleTone.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 05/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation

final class Singleton {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = Singleton()
    
    // MARK: Local Variable
    
    var isShowPopUpDialog = false
    var userInfo:[String:Any]?
    var userVerificationData = [String:Any]()
    
}
