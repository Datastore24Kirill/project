//
//  CreateTaskStepTwoModel.swift
//  Verifier
//
//  Created by Mac on 4/30/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct CreateTaskStepTwoTableModel {
    
    var type = TypeField.add
    
    enum TypeField {
        case add
        case choose
        case text
        case photo
        case video
        
    }
}
