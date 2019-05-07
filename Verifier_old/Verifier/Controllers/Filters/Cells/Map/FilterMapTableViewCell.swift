//
//  FilterRadiusTableViewCell.swift
//  Verifier
//
//  Created by Mac on 4/23/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import CoreLocation

class FilterMapTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: ShadowView!
    @IBOutlet weak var enterAddressTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    var mapVC = FilterMapViewController()
    
    var openSearchPlace = DelegetedManager<(())>()
    var preparePlace = DelegetedManager<(Place)>()
    var addThisViewControllerAsChild = DelegetedManager<(FilterMapViewController)>()
    var showOrHideSpinner = DelegetedManager<(Bool)>()
    
    enum ViewControllers: String {
        case map = "FilterMapVC"
    }

    // MARK: - UITableViewCell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = "Map filter".localized()
        prepareTextField()
    }
    
    //MARK: - Methods
    private func prepareTextField() {
        let placeHolderText = "Enter the address".localized()
        let placeHolerAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7689999938, green: 0.7839999795, blue: 0.8000000119, alpha: 1)]
        enterAddressTextField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: placeHolerAttributes)
    }
    
    func updateAddress(with place: Place?) {
        enterAddressTextField.text = place?.name ?? ""
        prepareMap(with: place)
    }
    
    func prepareMap(with place: Place?) {
        let storyboard = InternalHelper.StoryboardType.map.getStoryboard()
        mapVC = storyboard.instantiateViewController(withIdentifier: ViewControllers.map.rawValue) as! FilterMapViewController
        
        if let address = place {
            mapVC.coordinate = address.coordinate
        }
        
        mapVC.view.frame = mapView.bounds
        mapView.addSubview(mapVC.view)
        
        mapVC.didSelectMap.delegate(to: self) { (self, coordinate) in
            self.showOrHideSpinner.callback?(true)
            GoogleManager.getAddressByCoordinate(with: coordinate) {
                switch $0 {
                case .success(let name):
                    self.enterAddressTextField.text = name
                    let place = Place(cor: coordinate, name: name)
                    self.preparePlace.callback?(place)
                default: break
                }
                self.showOrHideSpinner.callback?(false)
            }
        }
        
        addThisViewControllerAsChild.callback?(mapVC)
    }
    
    //MARK: - Actions
    @IBAction func didEnterSymbolForAddress(_ sender: UITextField) {
    }
    
    @IBAction func didPressEnterAddressButton(_ sender: UIButton) {
        openSearchPlace.callback?(())
    }
    
}
