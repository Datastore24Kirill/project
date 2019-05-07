//
//  GoogleResponseBody.swift
//  Verifier
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct GoogleResponsePrediction: Codable {
    
    let status: String
    let predictions: [Prediction]
    
    struct Prediction: Codable {
        let description: String
    }
    
}
