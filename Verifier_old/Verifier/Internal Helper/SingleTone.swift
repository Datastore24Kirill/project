//
//  SingleTone.swift
//  Verifier
//
//  Created by Кирилл Ковыршин on 29/11/2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

// MARK: - Singleton

final class Singleton {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = Singleton()
    
    // MARK: Local Variable
    
    var isShowPopUpDialog = false
    
}
