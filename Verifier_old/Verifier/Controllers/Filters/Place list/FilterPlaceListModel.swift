//
//  FilterPlaceListModel.swift
//  Verifier
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct FilterPlaceListModel {
    
    func getPlaceList(with address: String, closure: @escaping (ServerResponse<[String]>)->()) {
        GoogleManager.getPlaceList(with: address) {
            closure($0)
        }
    }
    
    func getCoordinateByAddress(with address: String, closure: @escaping (ServerResponse<Place>)->()) {
        GoogleManager.getCoordinateByAddress(with: address) {
            closure($0)
        }
    }
}
