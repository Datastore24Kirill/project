//
//  GoogleManager.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 13/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//


import Foundation
import CoreLocation

struct GoogleManager {
    
    //MARK: - Properties
    static let domain = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let domain2 = "https://maps.googleapis.com/maps/api/"
    static let key = "AIzaSyAxTODQfUG37j-EIryr80yaC53BZ56-vzo" //"AIzaSyBwBl8ZIrGV27yk2QrfpLX42OqXyPcIaaI"
    
    enum URLLink {
        case getAddressByCoordinate
        case getCoordinateByAddress
        case getPlaceList
        
        func getURLLink(with parameter: [String: String] = [String: String]()) -> String {
            switch self {
            case .getAddressByCoordinate:
                let lat = parameter["lat"] ?? ""
                let lng = parameter["lng"] ?? ""
                return "latlng=\(lat),\(lng)&language=en&key=\(key)"
            case .getCoordinateByAddress:
                let address = parameter["address"] ?? ""
                return "key=\(key)&address=\(address)"
            case .getPlaceList:
                let isoCode = NSLocale.current.languageCode!
                let input = parameter["address"] ?? ""
                return "place/autocomplete/json?input=\(input)&components=country:\(isoCode)&key=\(key)"
            }
        }
    }
    
    //MARK: - Methods
    static func getCoordinate<T>(with url: URL, type: T, closure: @escaping (ServerResponse<T>)->()) {
        
    }
    
    static func getAddressByCoordinate(with coordinate: CLLocationCoordinate2D, closure: @escaping (ServerResponse<String>)->()) {
        
        let parameters: [String: String] = [
            "lat": String(coordinate.latitude),
            "lng": String(coordinate.longitude)
        ]
        
        var tmpAddress = [String]()
        guard let url = URL(string: domain + URLLink.getAddressByCoordinate.getURLLink(with: parameters)) else {
            closure(.serverError)
            return
        }
        
        RequestHendler().getCoordinate(with: url) {
            switch $0 {
            case .success(let res):
                guard let first = res.first else {
                    closure(.serverError)
                    return
                }
                
                first.addressComponents.forEach { address in
                    address.types.forEach {
                        if $0 == "locality" || $0 == "administrative_area_level_1" || $0 == "country" {
                            tmpAddress.append(address.shortName)
                        }
                    }
                }
                
                let name = tmpAddress.joined(separator: ", ")
                closure(.success(name))
            case .noInternet: closure(.noInternet)
            case .faild(alertText: let alert): closure(.faild(alertText: alert))
            case .serverError: closure(.serverError)
            }
        }
    }
    
    static func getCoordinateByAddress(with address: String, closure: @escaping (ServerResponse<Place>)->()) {
        
        guard let addpressWithPecent = address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            closure(.serverError)
            return
        }
        
        let parameters = [
            "address": addpressWithPecent,
            "key": key
        ]
        
        let strParameters = URLLink.getCoordinateByAddress.getURLLink(with: parameters)
        let strURL = "\(domain)\(strParameters)"
        guard let url = URL(string: strURL) else {
            closure(.serverError)
            return
        }
        
        RequestHendler().getCoordinate(with: url) {
            switch $0 {
            case .success(let result):
                guard let first = result.first else { return }
                
                let location = first.geometry.location
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: location.lat,
                    longitude: location.lng
                )
                
                let place = Place(cor: coordinate, name: address)
                closure(.success(place))
            case .noInternet: closure(.noInternet)
            case .faild(alertText: let alert): closure(.faild(alertText: alert))
            case .serverError: closure(.serverError)
            }
        }
        
    }
    
    static func getPlaceList(with address: String, closure: @escaping (ServerResponse<[String]>)->()) {
        
        guard let addpressWithPecent = address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            closure(.serverError)
            return
        }
        
        let parameters = [
            "address": addpressWithPecent,
            "key": key
        ]
        
        let strParameters = URLLink.getPlaceList.getURLLink(with: parameters)
        let strURL = "\(domain2)\(strParameters)"
        
        guard let url = URL(string: strURL) else {
            closure(.serverError)
            return
        }
        
        RequestHendler().getPlaceList(with: url) {
            closure($0)
        }
        
    }
    
    static func geocoderGetAddressByCoordinate(with coordinate: CLLocationCoordinate2D, closure: @escaping (ServerResponse<CLPlacemark>)->()) {
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                if let placemarks = placemarks {
                                                    let firstLocation = placemarks[0]
                                                    closure(.success(firstLocation))
                                                    
                                                } else {
                                                    closure(.serverError)
                                                }
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                closure(.serverError)
                                            }
        })
    }
    
    static func getError() -> [String: AnyObject] {
        return [
            "title": "Error" as AnyObject,
            "message": "Sorry, we can not define address. Please change location" as AnyObject] as [String: AnyObject]
    }
    
}

