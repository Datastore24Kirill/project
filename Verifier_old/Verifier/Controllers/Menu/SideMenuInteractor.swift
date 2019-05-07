//
//  PublicProfileFTInteractor.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import Foundation
import CoreLocation

protocol SideMenuInteractorInput: class {
    func fetchCoordinate(with nameCity: String)
    func fetchTasks(orderType: OrderTypeRequest)
}

protocol SideMenuInteractorOutput: class {
    func provideTasks(with tasks: [Task], result: ResponseResult)
    func provideCoordinate(with coordinate: ServerResponse<Place>)
}

class SideMenuInteractor: SideMenuInteractorInput {
    
    weak var presenter: SideMenuInteractorOutput!
    var apiRequestManager: RequestHendler!
    let decoder = JSONDecoder()
    
    struct RequestOrderFeed: Codable {
        var data: [OrderFeed]
    }
    
    struct OrderVerifierList {
        var start = "0"
        var count = "0"
    }
    
    func fetchTasks(orderType: OrderTypeRequest) {
        
        var tasks = [Task]()
        
        guard apiRequestManager.isInternetAvailable() else {
            presenter.provideTasks(with: tasks, result: .noInternet); return
        }
        
        let parameters = OrderVerifierList(start: "0", count: "0")
        apiRequestManager.orderCustomerList(with: parameters, orderTypeRequest: orderType) { res, serverResult in
            
            if let data = res {
                if let request = try? self.decoder.decode(RequestOrderFeed.self, from: data) {
                    request.data.forEach {

                        var task = Task()
                        task.id = $0.orderId
                        task.title = $0.orderName ?? "title"
                        task.tokens = Double($0.orderRate ?? 0)
                        task.text = $0.orderComment ?? ""
                        task.rating = Int($0.orderRating ?? 0)
                        task.city = $0.verifAddr ?? "Lviv"
                        
                        var status = 1
                        if $0.status == "ACCEPTED" {
                            status = 2
                        } else if $0.status == "VERIFIED" {
                            status = 3
                        } else if $0.status == "APPROVED" {
                            status = 4
                        } else if $0.status == "RETURNED_TO_VERIFIER" {
                            status = 5
                        } else {
                            print("unknown")
                        }
                        task.status = status
                        tasks.append(task)
                    }
                }
            }
            self.presenter.provideTasks(with: tasks, result: serverResult)
        }
    }
    
    func fetchCoordinate(with nameCity: String) {
        GoogleManager.getCoordinateByAddress(with: nameCity) { [weak self] in
            self?.presenter.provideCoordinate(with: $0)
        }
    }
}
