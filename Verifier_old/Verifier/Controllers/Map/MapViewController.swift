//
//  MapViewController.swift
//  Verifier
//
//  Created by Mac on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var mapView: GMSMapView!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
    var zoom: Float = 13.0
    var currentIsCollapse = true
    var markerIcon = #imageLiteral(resourceName: "map_marker_icon")
    
    //MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.layer.cornerRadius = 6
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareMap()
    }
    
    //MARK: Methods
    func prepareMap() {
        DispatchQueue.main.async {
            
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            
            self.mapView.clear()
            let camera = GMSCameraPosition.camera(withTarget: self.coordinate, zoom: self.zoom)
            self.mapView.camera = camera
            
            self.mapView?.settings.rotateGestures = false
            self.mapView?.isMyLocationEnabled = true
            self.mapView?.settings.myLocationButton = true
            
            let marker = GMSMarker(position: self.coordinate)
            marker.map = self.mapView
            marker.icon = self.imageWithImage(image: self.markerIcon)
            
        }
    }
    
    func imageWithImage(image: UIImage) -> UIImage {
        let newSize = CGSize(width: 25.0, height: 37.0)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    @nonobjc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            mapView?.isMyLocationEnabled = true
        }
    }
    
}
