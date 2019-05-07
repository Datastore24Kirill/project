//
//  DashboardDetailInteractor.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps

protocol DashboardDetailInteractorInput: class {
//    func fetchCoordinate(with nameCity: String)
    func fetchChangeTask(with id: Int, param: [String : Any])
}

protocol DashboardDetailInteractorOutput: class {
    func provideResultChangeTask(with result: ResponseResult)
//    func provideCoordinate(with coordinate: CLLocationCoordinate2D?, result: ResponseResult)
    func provideError()
}

class DashboardDetailInteractor: DashboardDetailInteractorInput {
    
    weak var presenter: DashboardDetailInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func fetchChangeTask(with id: Int, param: [String : Any]) {
        
        guard apiRequestManager.isInternetAvailable() else {
            if self.presenter != nil {
                self.presenter.provideResultChangeTask(with: .noInternet)
            }
            return
        }

//        apiRequestManager.orderAccept(id: id) {
//            if self.presenter != nil {
//                self.presenter.provideResultChangeTask(with: $0)
//            }
//        }
    }
    
//    func fetchCoordinate(with nameCity: String) {
//
//        guard apiRequestManager.isInternetAvailable() else {
//            if self.presenter != nil {
//                self.presenter.provideCoordinate(with: nil, result: .noInternet)
//            }; return
//        }
//
//        apiRequestManager.getCoordinate(with: nameCity) { res, serverResult in
//            if let results = res {
//                if self.presenter != nil {
//                    if let geometry = results[0]["geometry"] as? [String: Any],
//                        let location = geometry["location"] as? [String: Any],
//                        let lat = location["lat"] as? Double,
//                        let lng = location["lng"] as? Double {
//                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                        if self.presenter != nil {
//                            self.presenter.provideCoordinate(with: coordinate, result: serverResult)
//                        } else {
//                            self.presenter.provideError()
//                        }
//                    } else {
//                        if self.presenter != nil {
//                            self.presenter.provideCoordinate(with: nil, result: serverResult)
//                        } else {
//                            self.presenter.provideError()
//                        }
//                    }
//                }
//            } else {
//                self.presenter.provideError()
//            }
//        }
//    }
}
