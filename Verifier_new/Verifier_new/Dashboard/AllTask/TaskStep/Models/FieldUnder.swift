//
//  FieldUnder.swift
//  Verifier_new
//
//  Created by Nekich_Pekich on 3/11/19.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class FieldUnder: StepField {
    var fieldBlockchainHash:    String?
    
    override init(data: [String: Any]) {
        super.init(data: data)
        self.fieldBlockchainHash    = data["fieldBlockchainHash"]   as? String
    }
}
