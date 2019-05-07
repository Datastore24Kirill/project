//
//  LocationManager.swift
//  Verifier
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
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
