//
//  OrderFeed.swift
//  Verifier
//
//  Created by Mac on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct OrderFeed: Codable {
    var orderId: Int
    var orderRating: Double?
    var orderCreatedAt: Int64
    var orderName: String?
    var status: String?
    var orderRate: Double?
    var verifAddr: String?
    var orderComment: String?
}

enum OrderValidStatus {
    case isValid
    case noAnyItems
    case notFilled
}
