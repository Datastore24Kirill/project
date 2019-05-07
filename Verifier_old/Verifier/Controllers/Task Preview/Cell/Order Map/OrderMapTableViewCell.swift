//
//  OrderMapTableViewCell.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import GoogleMaps

class OrderMapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapContainerView: ShadowView!
    @IBOutlet weak var routeButton: UIButton!

    var isMapSetup = false
    var mapVC = TaskMapViewController()

    var newOrder = NewOrder()

    override func awakeFromNib() {
        super.awakeFromNib()

        setDesignChanges()
        localizeUIElement()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        routeButton.setBlackGradient(view: routeButton)
    }

    func setDesignChanges() {
        mapContainerView.layer.cornerRadius = 16.0
        mapContainerView.layer.shadowOffset.width = 0
        mapContainerView.layer.shadowOffset.height = 10
        mapContainerView.layer.shadowColor = UIColor.verifierGreyShadowColor().cgColor

        routeButton.layer.cornerRadius = 8.0
        routeButton.setBlackGradient(view: routeButton)

        routeButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
        routeButton.sizeToFit()
    }

    func localizeUIElement() {
        routeButton.setTitle("Map a route".localized(), for: .normal)
    }

    func prepareMap() {
        mapVC = R.storyboard.map.taskMapVC()!

        mapVC.coordinate = CLLocationCoordinate2D(latitude: newOrder.lat, longitude: newOrder.lng)

        if newOrder.lat != 0.0 {
            isMapSetup = true
        }

        mapVC.view.frame = mapContainerView.bounds
        mapContainerView.addSubview(mapVC.view)

        mapVC.prepareMap()
        //mapVC.mapView.isMyLocationEnabled = false
        //mapVC.mapView.settings.myLocationButton = false
    }

    func updateContentData() {
        if !isMapSetup {
            DispatchQueue.main.async {[weak self] in
                self?.prepareMap()
            }
        }
    }

    @IBAction func didPressBuildARouteButton(_ sender: UIButton) {
        InternalHelper.sharedInstance.googleMapsBuildARouteFromPoint(lat: Float(newOrder.lat), lng: Float(newOrder.lng), name: newOrder.orderName)
    }
}
