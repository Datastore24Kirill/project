//
//  User.swift
//  Verifier
//
//  Created by Mac on 11.01.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct User: Codable {
    
    static var sharedInstanse = User()

    var id: Int64?
    var token: String?
    var pushToken: String?
    var isPromoViewed: String?
    var password: String?
    var repeatPassword: String?
    var email: String?
    var phone: String?
    var firstName: String?
    var lastName: String?
    var type: String?
    var passportType: String?
    var passportSeries: String?
    var specialization: String?
    var issue: String?
    var birthDate: Int64?
    var issueCode: Int?
    var social: String?
    var promocode: String?
    
    var passportNumber: Int?
    var issueDate: Int64?
    var raiting: Float?
    var address: Address?

    var registrationStep: Int?
    var rating: Int?
    var balance: Double?
    
    var profilePhoto: Data?
    var photo: String?
    var companyName: String?
    
    var filter: Filter?
    
    
    
    
}

//MARK: Address
extension User {
    struct Address: Codable {
        var addressType: String?
        var country: String?
        var region: String?
        var city: String?
        var street: String?
        var house: String?
        var flat: String?
        var zipCode: String?
    }
}

//MARK: Filter
extension User {
    struct Filter: Codable {
        var rangeOfOrderExecution: String?
        var address: Place?
        var radius: String?
        var content: FilterContentModel?
    }
}
