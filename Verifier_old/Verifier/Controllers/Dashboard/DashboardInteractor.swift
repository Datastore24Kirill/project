//
//  VerifiInteractor.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import GoogleMaps

protocol DashboardInteractorInput: class {
    func fetchCoordinate(with nameCity: String)
    func fetchTasks()
    func fetchLogout()
    func getVerifierUser()
    func updateUser(with password: String)
}

protocol DashboardInteractorOutput: class {
    func provideTasks(with tasks: [Task], result: ResponseResult)
    func provideCoordinate(with res: ServerResponse<Place>)
    func provideGetUserResult(with result: ResponseResult)
    func provideUserLogoutResult(with result: ResponseResult)
    func dashboardViewShowAlert(with: String, message: String)
}

class DashboardInteractor: DashboardInteractorInput {
    
    weak var presenter: DashboardInteractorOutput!
    var apiRequestManager: RequestHendler!
    let decoder = JSONDecoder()
    
    struct RequestVerifierUser: Codable {
        var data: User
    }
    
    struct RequestOrderFeed: Codable {
        var data: [OrderFeed]
    }
    
    struct OrderFeedParameters {
        var start = "0"
        var count = "0"
        var dist = "0"
        var orderTypeId = "0"
    }
    
    //MARK: Methods
    func getVerifierUser() {
        
        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideGetUserResult(with: .noInternet); return
        }
        
        self.apiRequestManager.getVerifierUser { res, serverResult in
            if let data = res {
                if let requestUser = try? self.decoder.decode(RequestVerifierUser.self, from: data) {
                    var user = requestUser.data
                    let oldUser = UserDefaultsVerifier.getUser()
                    user.token = oldUser?.token
                    user.social = oldUser?.social
                    user.filter = oldUser?.filter
                    UserDefaultsVerifier.saveUser(with: user)
                }
            }
            
            self.presenter?.provideGetUserResult(with: serverResult)
        }
    }
    
    private func provideTasks() {
        var tasks = [Task]()
        guard let filter = UserDefaultsVerifier.getFilterParameters() else {
            self.presenter.provideTasks(with: tasks, result: .none)
            return
        }
        
        //{start} = для загрузки по частям
        //{count} = для загрузки по частям
        //{dist} = радиус, c пункта 2.3
        //{orderTypeId} = значение с пункта 2.4

        let radius = filter.radius ?? "0"
        var orderTypeId = "0"
        if let value = filter.content?.id {
            orderTypeId = String(value)
        }
        let parameters = OrderFeedParameters(start: "0", count: "0", dist: radius, orderTypeId: orderTypeId)

        
        
        self.apiRequestManager.getOrderFeed(with: parameters) { res, serverResult in
            if let data = res {
               
                if let request = try? self.decoder.decode(RequestOrderFeed.self, from: data) {
                    print("REQUEST DATA \(request.data)")
                    request.data.forEach {
                        var task = Task()
                        task.id = $0.orderId
                        task.title = $0.orderName ?? "title"
                        task.tokens = Double($0.orderRate ?? 0)
                        task.text = $0.orderComment ?? ""
                        task.rating = Int($0.orderRating ?? 0)
                        task.status = 1
                        task.city = $0.verifAddr ?? "Moscow"
                        tasks.append(task)
                    }
                }
            }

            self.presenter.provideTasks(with: tasks, result: serverResult)
        }
    }
    
    func fetchTasks() {
        guard let lat = LocationManager.share.currentLocation?.latitude,
            let lng = LocationManager.share.currentLocation?.longitude else {
                self.presenter.provideTasks(with: [Task](), result: .none)
                return
        }
        
        self.apiRequestManager.setUserLocation(
        parameters: ["latitude": lat, "longitude": lng]) { (res) in
            switch res {
            case .success:
                self.provideTasks()
            default:
                self.presenter.provideTasks(with: [Task](), result: .none)
            }
        }
    }
    
    
    func fetchCoordinate(with nameCity: String) {
        GoogleManager.getCoordinateByAddress(with: nameCity) { [weak self] in
            self?.presenter.provideCoordinate(with: $0)
        }
    }
    
    func fetchLogout() {
        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideUserLogoutResult(with: .noInternet); return
        }
        
        apiRequestManager.verifierLogout {
            if self.presenter != nil {
                UserDefaultsVerifier.deleteUser()
                self.presenter.provideUserLogoutResult(with: $0)
            }
        }
    }
    
    func updateUser(with password: String) {
        let parameters = [ "password": password ]
        apiRequestManager.verifierUpdate(parameters: parameters) { (result) in
            switch result {
            case .success:
                self.presenter.dashboardViewShowAlert(
                    with: "Done".localized(),
                    message: "Success change personal info".localized()
                )
            default:
                self.presenter.dashboardViewShowAlert(
                    with: "InternetErrorTitle".localized(),
                    message: ""
                )
            }
        }
    }
}
