//
//  FiltersModel.swift
//  Verifier
//
//  Created by Mac on 4/26/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct FilterModel {
    
    //MARK: - Properties
    var apiRequestManager = RequestHendler()
    var prepareSaveLocation = DelegetedManager<(ServerResponse<()>)>()
    
    //MARK: - Methods
    func getContentList(closure: @escaping (ServerResponse<[FilterContentModel]>)->()) {
        apiRequestManager.getContentList {
            closure($0)
        }
    }
    
    func saveUserLocation(with address: Place) {
        let lat = address.coordinate.latitude
        let lng = address.coordinate.longitude
        
        apiRequestManager.setUserLocation(parameters: ["latitude": lat, "longitude": lng]) {
            self.prepareSaveLocation.callback?($0)
        }
    }
    
    func getRangeOfOrderExecutionList() -> [String] {
        return [
            "Today".localized(),
            "Tomorrow".localized(),
            "Within 1 week".localized(),
            "Within 1 month".localized(),
            "All".localized()
        ]
    }
    
    func getRadiusList() -> [String] {
        return Array(1...20).map { String($0) }
    }
    
    func getCellIndentifier() -> [String] {
        
        return [
            CellIdentifiersUINibs.Indentifiers.filterRangeOfOrderExecutionViewCell.rawValue,
            CellIdentifiersUINibs.Indentifiers.filterMapTableViewCell.rawValue,
            CellIdentifiersUINibs.Indentifiers.filterRadiusTableViewCell.rawValue,
            CellIdentifiersUINibs.Indentifiers.filterContentTableViewCell.rawValue
        ]
    }
    
    func getFilterDataHeaderList() -> [FilterDataHeaderModel] {
        
        let titles = [
            "By time of execution".localized(),
            "By address".localized(),
            "By radius".localized(),
            "By contents".localized()
        ]
        
        return titles.map { FilterDataHeaderModel(opened: false, title: $0, isHiddenDot: true) }
    }
}
