//
//  FilterMapViewController.swift
//  Verifier
//
//  Created by Mac on 4/28/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import GoogleMaps

class FilterMapViewController: MapViewController, GMSMapViewDelegate {
    
    var didSelectMap = DelegetedManager<CLLocationCoordinate2D>()
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool { return false }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        self.mapView.clear()
        marker.map = self.mapView
        marker.icon = imageWithImage(image: markerIcon)
        didSelectMap.callback?(coordinate)
    }
}
