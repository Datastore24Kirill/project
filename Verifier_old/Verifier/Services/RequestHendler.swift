//
//  RequestHendler.swift
//  Verifier
//
//  Created by Mac on 28.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

class RequestHendler {
    
    //Test
    //let domain = "http://88.212.253.87:8181/verifier/api/v1/"
    
    //Prod
    //let domain = "http://82.202.163.10:8181/verifier/api/v1/"
    let domain = "http://82.202.163.10:8181/verifier/api/v1/"
                         
    var timestamp: String {
        return "\(CUnsignedLongLong(Date().timeIntervalSince1970 * 1000))"
    }
    
    enum UrlLink {
        case verifierLogin, verifierRegistration, verifierUpdate, verifierUser, verifierLogout
        case orderFeed, order, orderAccept, orderVerifierList, orderCustomerList, orderVerify
        case verifierUpload
        case userLocation
        case userSettings
        case userWalletAddress
        case sendFeedback
        case addOrder
        case verify
        case orderApproval
        case orderReturn
        case push
        case passReset
        case resendVerifierEmail
        
        //Filter
        case getContentList
        
        func getUrlLink(urlParameter: String = "", urlParameter2: String = "", urlParameter3: String = "", urlParameter4: String = "") -> String {
            switch self {
            case .push:
                return "push/"
            case .verifierLogin:
                return "user/verifier/login"
            case .verifierRegistration:
                return "user/verifier/registration"
            case .verifierUpdate:
                return "user/verifier/update"
            case .verifierUser:
                return "user/verifier/0"
            case .verifierLogout:
                return "user/logout"
            case .passReset:
                return "user/verifier/passreset"
            case .orderFeed:
                return "order/feed/\(urlParameter)/\(urlParameter2)/\(urlParameter3)/\(urlParameter4)"
            case .order:
                return "order/\(urlParameter)"
            case .orderAccept:
                return "order/accept/\(urlParameter)"
            case .orderCustomerList:
                return "order/customer/list/\(urlParameter)/\(urlParameter2)"
            case .orderVerifierList:
                return "order/verifier/list/\(urlParameter)/\(urlParameter2)"
            case .verifierUpload:
                return "order/file/upload"
            case .orderVerify:
                return "order/verify"
            case .userLocation:
                return "user/location"
            case .userSettings:
                return "user/verifier/settings"
            case .userWalletAddress:
                return "user/verifier/wallet"
            case .sendFeedback:
                return "user/verifier/mail"
            case .getContentList:
                return "order/type/list"
            case .addOrder:
                return "order/add"
            case .verify:
                return "user/verifier/verify"
            case .orderApproval:
                return "order/approval"
            case .orderReturn:
                return "order/return"
            case .resendVerifierEmail:
                return "user/verifier/resend/email/confirmation"
            }
        }
    }
    
    
    //MARK: - Set manager
    
    func getSessionManager(url: URL) -> SessionManager {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        return sessionManager
    }
    
    
    //MARK: - Check internet connection
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    //MARK: - Set User Location
    
    func setUserLocation(parameters: [String: Any], closure: @escaping (ServerResponse<()>) -> ()) {
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        let url = URL(string: self.domain + UrlLink.userLocation.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                 print("setUserLocation ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success(()))
                    } else {
                        closure(.serverError)
                    }
                    break
                case .failure(let error):
                    print("setUserLocation ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
    }
    
    
    //MARK: - Login
    
    func verifierLogin(parameters: [String: Any], closure: @escaping (String?,String?, ResponseResult) -> ()) {
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domain + UrlLink.verifierLogin.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("Lets login \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: String],
                        let token = data["token"],
                        let isTempPassword = data["isTempPassword"]
                    {
                        closure(isTempPassword, token, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure("false", nil, .failed(String(code)))
                        }else{
                                closure(nil, nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierLogin ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Login
    
    func verifierResetPassword(parameters: [String: Any], closure: @escaping (String?, ResponseResult) -> ()) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        let url = URL(string: self.domain + UrlLink.passReset.getUrlLink())
        print("URL \(url)")
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("Reset Passowrd --> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200
                    {
                        closure(String(statusCode), .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("verifierResetPassword ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - ResendVerifierEmail
    
    func resendVerifierEmail(parameters: [String: Any], closure:  @escaping (ResponseResult) -> ()) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domain + UrlLink.resendVerifierEmail.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success)
                    } else {
                        closure(.failed(""))
                    }
                    break
                case .failure(let error):
                    print("resendVerifierEmail ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Logout
    
    func verifierLogout(closure:  @escaping (ResponseResult) -> ()) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        let url = URL(string: self.domain + UrlLink.verifierLogout.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: nil, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success)
                    } else {
                        closure(.failed(""))
                    }
                    break
                case .failure(let error):
                    print("verifierLogout ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    func push(parameters: [String: Any], closure: @escaping (ResponseResult) -> ()) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        let url = URL(string: self.domain + UrlLink.push.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success)
                    } else {
                        closure(.failed(""))
                    }
                    break
                case .failure(let error):
                    print("push ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Registration
    
    func verifierRegistration(parameters: [String: Any], closure: @escaping (String?, ResponseResult) -> ()) {
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domain + UrlLink.verifierRegistration.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("verifierRegistration ->> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200{
                        closure(nil, .success)
                    }else if let res = response.result.value as? [String: AnyObject],
                        let code = res["code"] as? Int {
                        closure(nil, .failed(String(code)))
                    }else{
                        closure(nil, .failed(""))
                    }
                case .failure(_):
                    closure(nil, .failed(""))
                }
        }
    }
    
    
    //MARK: - Update
    
    func verifierUpdate(parameters: [String: Any], closure: @escaping (ResponseResult) -> ()) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        
        let url = try! URLRequest(url: self.domain + UrlLink.verifierUpdate.getUrlLink(), method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = User.sharedInstanse.profilePhoto {
                multipartFormData.append(imageData, withName: "photo", fileName: "\(self.timestamp)_photo\((imageData.fileExtension))", mimeType: "image/*")
            }
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, with: url, encodingCompletion: { (result) in
            
            switch result {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success)
                    } else {
                        
                        let statusCode = (response.response?.statusCode)!
                        if statusCode == 401 {
                            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.reloginUser()
                        } else {
                            closure(.serverError(""))
                        }
                    }
                }
                
            case .failure(let encodingError):
                closure(.serverError(encodingError.localizedDescription))
            }
        })
        
    }
    
    
    //MARK: - Get User
    
    func getVerifierUser(closure:  @escaping (Data?, ResponseResult) -> ()) {
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.verifierUser.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let data = response.data {
                        closure(data, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("getVerifierUser ---> " + error.localizedDescription)
                    
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.reloginUser()
                        } else {
                            closure(nil, .serverError(error.localizedDescription))
                        }
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Get Order Feed
    
    func getOrderFeed(with parameters: DashboardInteractor.OrderFeedParameters, closure:  @escaping (Data?, ResponseResult) -> ()) {
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        
        let stringParameters = UrlLink.orderFeed.getUrlLink(
            urlParameter: parameters.dist,
            urlParameter2: parameters.orderTypeId,
            urlParameter3: parameters.start,
            urlParameter4: parameters.count
        )
        
        let url = URL(string: self.domain + stringParameters)
        print("URL \(url!)")
        let sessionManager = self.getSessionManager(url: url!)
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getOrderFeed --->  \(response)")
                switch (response.result) {
                case .success(_):
                    if let data = response.data {
                        closure(data, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("getOrderFeed ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Get user settings
    
    func getUserSettings(closure:  @escaping (ServerResponse<UserSettings>) -> ()) {
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.userSettings.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData {
                sessionManager.session.invalidateAndCancel()
                
                switch $0.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let dataBody = try? decoder.decode(ResponseBody<UserSettings>.self, from: data),
                        dataBody.statusCode == 200, let settings = dataBody.data else {
                            closure(.serverError)
                            return
                    }
                    closure(.success(settings))
                case .failure(let error):
                    print("getUserSettings ---> " + error.localizedDescription)
                    
                    let statusCode = ($0.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
    }
    
    
    //MARK: - Get Order Feed
    
    func getOrder(id: Int, closure:  @escaping (Data?, ResponseResult) -> ()) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.order.getUrlLink(urlParameter: String(id)))
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let data = response.data {
                        closure(data, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("getOrderFeed ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Order Accept
    
    func orderAccept(id: Int, closure: @escaping (Bool) -> Void) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.orderAccept.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: ["orderId": id], encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(true)
                    } else {
                        closure(false)
                    }
                    break
                case .failure(let error):
                    print("orderAccept ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(false)
                    }
                }
        }
    }
    
    
    //MARK: - Order Verifier List
    
    func orderCustomerList(with parameters: SideMenuInteractor.OrderVerifierList, orderTypeRequest: OrderTypeRequest, closure:  @escaping (Data?, ResponseResult) -> ()) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        
        var url = URL(string: self.domain + UrlLink.orderCustomerList.getUrlLink(urlParameter: parameters.start, urlParameter2: parameters.count))
        
        switch orderTypeRequest {
        case .myOrder:
            url = URL(string: self.domain + UrlLink.orderCustomerList.getUrlLink(urlParameter: parameters.start, urlParameter2: parameters.count))
        case .verifyOrder:
            url = URL(string: self.domain + UrlLink.orderVerifierList.getUrlLink(urlParameter: parameters.start, urlParameter2: parameters.count))
        }
        
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let data = response.data {
                        closure(data, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("orderVerifierList ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Attach File
    func attachFile(with index: Int, image: UIImage, closure:  @escaping (ServerResponse<(Int, String)>) -> ()) {
        
        let url = URL(string: domain + UrlLink.verifierUpload.getUrlLink())
        print("URL UPLOAD \(url)")
        let configuration = URLSessionConfiguration.default
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        var requestUrl = try! URLRequest(url: url!, method: .post, headers: headers)
        requestUrl.timeoutInterval = 99999
        
        do {
            let encodedURLRequest = try URLEncoding.queryString.encode(requestUrl, with: nil)
            
            let sessionManager = Alamofire.SessionManager(configuration: configuration)
            
            
            sessionManager.upload(multipartFormData: { multipartFormData in
                
                //for image in images {
                let imageData = UIImageJPEGRepresentation(InternalHelper.sharedInstance.normalizedImage(img: image), 0.6)
                multipartFormData.append(imageData!, withName: "file", fileName: "\(self.timestamp)_photo\((imageData?.fileExtension)!)", mimeType: "image/*")
                //}
                
            }, with: encodedURLRequest, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        sessionManager.session.invalidateAndCancel()
                        
                        if let res = response.result.value as? [String: AnyObject],
                            let statusCode = res["statusCode"] as? Int, statusCode == 200,
                            let data = res["data"] as? [String: String], let link = data["link"] {
                             print("PHOTOLINK \(data["link"])")
                            closure(.success((index, link)))
                        } else {
                            let statusCode = (response.response?.statusCode)!
                            if statusCode == 401 {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.reloginUser()
                            } else {
                                closure(.serverError)
                            }
                        }
                    }
                case .failure(let encodingError):
                    print("attachFile: \(encodingError)")
                    closure(.serverError)
                }
            })
        } catch {
            closure(.serverError)
        }
    }
    
    
    //MARK: - Attach Video File
    
    func attachFile(with index: Int, video: Data, closure:  @escaping (ServerResponse<(Int, String)>) -> ()) {
        
        let url = URL(string: domain + UrlLink.verifierUpload.getUrlLink())
        print("URL UPLOAD \(url)")
        let configuration = URLSessionConfiguration.default
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        var requestUrl = try! URLRequest(url: url!, method: .post, headers: headers)
        requestUrl.timeoutInterval = 99999
        
        do {
            let encodedURLRequest = try URLEncoding.queryString.encode(requestUrl, with: nil)
            
            let sessionManager = Alamofire.SessionManager(configuration: configuration)
            
            sessionManager.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(video, withName: "file", fileName: "\(self.timestamp)_video.mov", mimeType: "video/*")
                
            }, with: encodedURLRequest, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        sessionManager.session.invalidateAndCancel()
                        
                        if let res = response.result.value as? [String: AnyObject],
                            let statusCode = res["statusCode"] as? Int, statusCode == 200,
                            let data = res["data"] as? [String: String], let link = data["link"] {
                            print("VIDEOLINK \(data["link"])")
                            closure(.success((index, link)))
                        } else {
                            
                            let statusCode = (response.response?.statusCode)!
                            if statusCode == 401 {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.reloginUser()
                            } else {
                                closure(.serverError)
                            }
                        }
                    }
                case .failure(let encodingError):
                    print("attachFile: \(encodingError.localizedDescription)")
                    
                    closure(.serverError)
                }
            })
        } catch {
            closure(.serverError)
        }
    }
    
    
    //MARK: - Change task
    
    func orderVerifier(parameters: [String: AnyObject], closure:  @escaping (ResponseResult) -> ()) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.orderVerify.getUrlLink())
       
        let sessionManager = self.getSessionManager(url: url!)
        print("PARAMS \(parameters)")
        sessionManager.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("RESP \(response)")
                guard response.response?.statusCode != 400 else {
                    closure(.serverError("400"))
                    return
                }
                
                switch (response.result) {
                case .success(_):
                    
                    let rest = response.result.value! as? [String: AnyObject]
                    print(rest!["code"])
                    
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success)
                    }else if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["code"] as? Int, statusCode == 403003 {
                        closure(.serverError(String(statusCode)))
                    } else {
                        closure(.failed(""))
                    }
                    break
                case .failure(let error):
                    print("orderVerifier ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Order Accept
    
    func setUserWalletAddress(address: String, closure: @escaping ([String: AnyObject]?, ResponseResult) -> Void) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.userWalletAddress.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .post, parameters: ["blockChainWallet": address], encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(res, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("setUserWalletAddress ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .failed(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Filte
    
    func getContentList(closure: @escaping (ServerResponse<[FilterContentModel]>)->()) {
        
        let token = UserDefaultsVerifier.getToken()
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.getContentList.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData {
                sessionManager.session.invalidateAndCancel()
                
                switch $0.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard
                        let dataBody = try? decoder.decode(ResponseBody<[FilterContentModel]>.self, from: data),
                        dataBody.statusCode == 200,
                        let list = dataBody.data else {
                            closure(.serverError)
                            return
                    }
                    
                    closure(.success(list))
                case .failure(let error):
                    print("getContentList ---> " + error.localizedDescription)
                    
                    let statusCode = ($0.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
    }
    
    
    //MARK: - Send Feedback
    
    func sendFeedBack(subject: String, text: String, closure: @escaping ([String: AnyObject]?, ResponseResult) -> Void) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.sendFeedback.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        let parameters = [
            "feedbackName": subject,
            "feedbackText": text]
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(res, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("setUserWalletAddress ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .failed(error.localizedDescription))
                        
                    }
                }
        }
    }
    
    
    //MARK: - Google
    
    func getCoordinate(with url: URL, closure:  @escaping (ServerResponse<[GoogleResponseResult.Results]>) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let sessionManager = getSessionManager(url: url)
        sessionManager.request(url, method: .get, parameters: nil, encoding:  URLEncoding.default, headers: headers)
            .validate()
            .responseData {
                sessionManager.session.invalidateAndCancel()
                
                switch $0.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard
                        let dataBody = try? decoder.decode(GoogleResponseResult.self, from: data),
                        dataBody.status == "OK" else {
                            closure(.serverError)
                            return
                    }
                    
                    closure(.success(dataBody.results))
                case .failure(let error):
                    print("getCoordinateByAddress ---> " + error.localizedDescription)
                    
                    let statusCode = ($0.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
        
    }
    
    func getPlaceList(with url: URL, closure: @escaping (ServerResponse<[String]>) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let sessionManager = getSessionManager(url: url)
        
        sessionManager.request(url, method: .get, parameters: nil, encoding:  URLEncoding.default, headers: headers)
            .validate()
            .responseData {
                sessionManager.session.invalidateAndCancel()
                
                switch $0.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard
                        let dataBody = try? decoder.decode(GoogleResponsePrediction.self, from: data),
                        dataBody.status == "OK" else {
                            closure(.serverError)
                            return
                    }
                    
                    let list = dataBody.predictions.map { $0.description }
                    closure(.success(list))
                case .failure(let error):
                    print("getPlaceList ---> " + error.localizedDescription)
                    
                    let statusCode = ($0.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
    }
    
    
    //MARK: - Other
    
    private func normalizedImage(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage;
    }
    
    
    //MARK: - Order Add
    
    func addOrder(closure: @escaping ([String: AnyObject]?, ResponseResult) -> Void) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.addOrder.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        var fields: [[String: String]] = [[String: String]]()
        
        for field in NewOrder.sharedInstance.fields {
            let temp = [
                "fieldType": field.type,
                "fieldName": field.label,
                "fieldDescription": field.name,
                "fieldData": "",
                "fieldMinCount": field.minCount
            ]
            fields.append(temp)
        }
        
        if NewOrder.sharedInstance.selectedSubject == nil {
            return
        }
        
        let params = [
            "orderName": NewOrder.sharedInstance.orderName,
            "orderRate": "1.0",
            "orderComment": NewOrder.sharedInstance.orderComment,
            "verifAddr": NewOrder.sharedInstance.address,
            "verifAddrLongitude": "\(NewOrder.sharedInstance.lng)",
            "verifAddrLatitude": "\(NewOrder.sharedInstance.lat)",
            "verifTimeFrom": "\(Int((NewOrder.sharedInstance.dateFrom.timeIntervalSince1970).rounded()))",
            "verifTimeTo": "\(Int((NewOrder.sharedInstance.dateTo.timeIntervalSince1970).rounded()))",
            "orderTypeId": "\((NewOrder.sharedInstance.selectedSubject?.id)!)",
            "orderFields": fields
            ] as [String : Any]
        
        sessionManager.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(res, .success)
                    } else {
                        closure(nil, .failed("Some error happend"))
                    }
                    break
                case .failure(let error):
                    print("addOrder ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .failed(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Verify
    
    func verifierVerify(verifAddr: String,
                        long: Double,
                        lat: Double,
                        timeTo: Int,
                        closure:  @escaping (ResponseResult) -> ()) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": UserDefaultsVerifier.getToken()]
        let url = URL(string: self.domain + UrlLink.verify.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let timeFrom = Int((Date().timeIntervalSince1970).rounded())
        
        let parameters: [String : Any] = [
            "verifAddr": verifAddr,
            "verifAddrLongitude": long,
            "verifAddrLatitude": lat,
            "verifTimeFrom": timeFrom,
            "verifTimeTo": timeTo
        ]
        
        sessionManager.request(url!,
                               method: .post,
                               parameters: parameters,
                               encoding:  JSONEncoding.default,
                               headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(.success)
                    } else {
                        //let error = (response.result.value as? [String: AnyObject])?["error"] as? String
                        closure(.failed("Verify info error".localized()))
                    }
                    break
                case .failure(let error):
                    print("verifierLogout ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Order Approval
    
    func orderApproval(orderId: Int64, closure: @escaping ([String: AnyObject]?, ResponseResult) -> Void) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.orderApproval.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        let parameters = ["orderId": orderId]
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(res, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("setUserWalletAddress ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .failed(error.localizedDescription))
                        
                    }
                }
        }
    }
    
    
    //MARK: - Order Return
    
    func orderReturn(orderId: Int64, reason: String, closure: @escaping ([String: AnyObject]?, ResponseResult) -> Void) {
        
        let token = UserDefaultsVerifier.getToken()
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.orderReturn.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        let parameters = ["orderId": orderId,
                          "reason": reason] as [String : Any]
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(res, .success)
                    } else {
                        closure(nil, .failed(""))
                    }
                    break
                case .failure(let error):
                    print("setUserWalletAddress ---> " + error.localizedDescription)
                    
                    let statusCode = (response.response?.statusCode)!
                    if statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .failed(error.localizedDescription))
                        
                    }
                }
        }
    }
    
    
    // MARK: - Validate
    
    func isValidate(token: String, closure:  @escaping (ServerResponse<Bool>) -> ()) {
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.userSettings.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData {
                sessionManager.session.invalidateAndCancel()
                
                switch $0.result {
                case .success:
                    closure(.success(true))
                default:
                    closure(.serverError)
                }
        }
    }
}
