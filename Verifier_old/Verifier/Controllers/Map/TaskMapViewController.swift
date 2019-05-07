//
//  TaskMapViewController.swift
//  Verifier
//
//  Created by Mac on 4/28/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import GoogleMaps

class TaskMapViewController: MapViewController, GMSMapViewDelegate {
    
    var didSelectMap = DelegetedManager<()>()
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool { return false }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        didSelectMap.callback?(())
    }
}
