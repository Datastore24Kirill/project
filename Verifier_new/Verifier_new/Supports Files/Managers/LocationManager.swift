//
//  LocationManager.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject {
    
    static let share = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    private override init() {
        
    }
    
    func setup() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
}
