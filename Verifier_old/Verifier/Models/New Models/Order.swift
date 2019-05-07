//
//  Order.swift
//  Verifier
//
//  Created by Mac on 12.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct Order: Codable {
    var userId: Int64
    var isMyOrder: Bool
    var orderRating: Int
    var verifTimeTo: Int64
    var orderName: String?
    var verifAddr: String
    var verifTimeFrom: Int64
    var orderRate: Double
    var orderComment: String
    var orderFields: [OrderFields]
    var verifAddrLongitude: Double
    var verifAddrLatitude: Double
    
    struct OrderFields: Codable {
        var fieldType: String?
        var fieldName: String?
        var fieldDescription: String?
        var fieldData: String?
        var fieldMinCount: String?
    }
}
