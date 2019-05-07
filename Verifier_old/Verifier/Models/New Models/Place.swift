//
//  Place.swift
//  Verifier
//
//  Created by Mac on 4/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import CoreLocation

struct Place: Codable {
    var latitude: Double
    var longitude: Double
    var coordinate = CLLocationCoordinate2D()
    var name = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }
    
    init(cor: CLLocationCoordinate2D, name: String) {
        self.coordinate = cor
        self.name = name
        self.latitude = self.coordinate.latitude
        self.longitude = self.coordinate.longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
}

extension Place: Equatable {}

func ==(lhs: Place, rhs: Place) -> Bool {
    let res = lhs.name == rhs.name &&
    lhs.coordinate.latitude == rhs.coordinate.latitude &&
    lhs.coordinate.longitude == rhs.coordinate.longitude
    
    return res
}
