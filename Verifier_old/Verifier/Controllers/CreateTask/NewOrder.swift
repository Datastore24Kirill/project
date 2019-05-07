//
//  NewOrder.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 02.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

enum OrderType {
    case new
    case inProgress
}

class NewOrder {
    static let sharedInstance = NewOrder()

    var dateFrom: Date = Date()
    var dateTo: Date = Date()
    
    var selectedSubject: FilterContentModel? = nil

    var userId: Int64 = -1

    var orderName: String = ""
    var orderComment: String = ""
    
    var orderFirstName: String = ""
    var orderLastName: String = ""
    var orderMiddleName: String = ""
    
    var isPhisical: Bool = false
    var isMyOrder: Bool = false
    
    var lat: Double = 0.0
    var lng: Double = 0.0
    var address: String = ""

    var orderRating: Int = 0
    var orderRate: Double = 0.0

    var ordetType: OrderType = .new

    var fields: [Field] = [Field]()

    
    func resetFields() {
        fields.removeAll()
    }
    
}
