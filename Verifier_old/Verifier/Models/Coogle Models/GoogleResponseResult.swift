//
//  GoogleResponseResult.swift
//  Verifier
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct GoogleResponseResult: Codable {
    
    let status: String
    let results: [Results]
    
    struct Results: Codable {
        let geometry: Geometry
        let addressComponents: [AddressComponent]
        
        struct Geometry: Codable {
            let location: Location
            
            struct Location: Codable {
                let lat: Double
                let lng: Double
            }
        }
        
        struct AddressComponent: Codable {
            let longName: String
            let shortName: String
            let types: [String]
        }
    }
    
}
