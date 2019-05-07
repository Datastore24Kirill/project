//
//  GoogleMapManager.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/31/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class GoogleMapManager: NSObject {
    
    let defaultPlace = CLLocationCoordinate2D(latitude: 55.740557, longitude: 37.610006)
    var didGetNewCoordinat = DelegetedManager<(coordinate: CLLocationCoordinate2D, address: String)>()
    var didGetNewCoordinatError = DelegetedManager<(title: String, message: String)>()
    
    private var mapVC = FilterMapViewController()
    private var mapView: UIView!
    
    init(mapView: UIView) {
        self.mapView = mapView
    }
    
    func prepareMap(with place: Place?) {
        mapVC = R.storyboard.map.filterMapVC()!
        if let address = place {
            mapVC.coordinate = address.coordinate
        } else {
            mapVC.coordinate = defaultPlace
        }
        self.getCoordinates(coordinate: mapVC.coordinate)
        
        mapVC.view.frame = mapView.bounds
        mapView.addSubview(mapVC.view)
        
        mapVC.prepareMap()
        mapVC.didSelectMap.delegate(to: self) { (self, coordinate) in
            self.getCoordinates(coordinate: coordinate)
        }
    }
    
    private func getCoordinates(coordinate: CLLocationCoordinate2D) {
        GoogleManager.geocoderGetAddressByCoordinate(with: coordinate) { [weak self] in
            switch $0 {
            case .success(let location):
                let country = location.addressDictionary!["Country"] ?? ""
                let state = location.addressDictionary!["State"] ?? ""
                let name = location.addressDictionary!["Name"] ?? ""
                let address = "\(country), \(state), \(name)"
                self?.didGetNewCoordinat.callback?((coordinate: coordinate, address: address))
            case .faild(let alertText):
                self?.didGetNewCoordinatError.callback?((
                    title: alertText.title,
                    message: alertText.message
                ))
            case .serverError:
                self?.didGetNewCoordinatError.callback?((
                    title: "InternetErrorTitle".localized(), message: ""
                ))
            case .noInternet:
                self?.didGetNewCoordinatError.callback?((
                    title: "InternetErrorTitle".localized(),
                    message: "InternetErrorMessage".localized()
                ))
            }
        }
    }
}


//MARK: - GMSAutocompleteViewControllerDelegate

extension GoogleMapManager: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true) { [weak self] in
            let place = Place(cor: place.coordinate, name: place.formattedAddress ?? place.name)
            self?.prepareMap(with: place)
//            self?.didGetNewPlace.callback?((place))
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        viewController.dismiss(animated: true, completion: nil)
    }
}

