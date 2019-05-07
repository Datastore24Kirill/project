//
//  APIRequestHendler.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

class RequestHendler {
    
    //Test
    //let domain = "http://88.212.253.87:8181/verifier/api/v1/"
    
    //Prod
    //let domain = "http://82.202.165.178:8181/verifier/api/v1/"
    let domain = "http://88.212.253.87:8181/verifier/api/v1/"
    let domainv2 = "http://88.212.253.87:8181/verifier/api/v2/"
    let resultRealm = RealmSwiftAction.listRealm()
    let resultFilterRealm = RealmSwiftFilterAction.listRealm()
    var timestamp: String {
        return "\(CUnsignedLongLong(Date().timeIntervalSince1970 * 1000))"
    }
    
    enum UrlLink {
        case verifierLogin, verifierRegistration, verifierUpdate, verifierUser, verifierLogout, verifierLoginFB, verifierLoginVK
        case orderFeed, order, orderStep, orderAccept, myOrderFeed, orderStepData, orderRate, orderStepList
        case verifierUpload
        case userLocation
        case userSetData
        case userSettings
        case userDocumentsList
        case userDocumentDownload
        case userWalletAddress
        case sendFeedback
        case verify
        case push
        case passReset
        case resendVerifierEmail
        case checkVerifierEmail
        case changepassword
        case checkToken
        case chatBranch
        
        case getBadges
        case notificationList
        case notificationRead
        case notificationAllRead
        
        //Filter
        case getContentList
        case getOrderFilterData
        
        
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
            case .userSetData:
                return "user/verifier/setdata"
            case .verifierLogout:
                return "user/logout"
            case .passReset:
                return "user/verifier/passreset"
            case .orderFeed:
                return "order/feed/"
            case .order:
                return "order/"
            case .orderStep:
                return "order/step/"
            case .orderStepList:
                return "order/step/list/"
            case .orderAccept:
                return "order/accept"
            case .myOrderFeed:
                return "order/verifier/list/"
            case .orderStepData:
                return "order/step/data"
            case .orderRate:
                return "order/rating"
            

            case .verifierUpload:
                return "order/file/upload"
            case .userLocation:
                return "user/location"
            case .userSettings:
                return "user/verifier/settings"
                
            case .userDocumentsList:
                return "user/verifier/document/list"
            case .userDocumentDownload:
                return "user/verifier/document/download"
                
            case .userWalletAddress:
                return "user/verifier/wallet"
            case .sendFeedback:
                return "user/verifier/mail"
            case .getContentList:
                return "order/type/list"
            case .getOrderFilterData:
                return "order/filter/data"
            case .verify:
                return "user/verifier/verify"
            case .resendVerifierEmail:
                return "user/verifier/resend/email/confirmation"
            case .verifierLoginFB:
                return "user/verifier/login/facebook"
            case .verifierLoginVK:
                return "user/verifier/login/vk"
            case .checkVerifierEmail:
                return "user/check/email"
            case .changepassword:
                return "user/password/set"
            case .checkToken:
                return "user/check/token"
            case .chatBranch:
                return "chat/branch/"
            case .getBadges:
                return "user/verifier/badges"
            case .notificationList:
                return "notification/list/"
            case .notificationRead:
                return "notification/read"
            case .notificationAllRead:
                return "notification/read/all"
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
        
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domain + UrlLink.userLocation.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
    }
    
    //MARK: - USER SET DATA
    
    func verifierUserSetData(parameters: [String: Any], closure: @escaping (ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domainv2 + UrlLink.userSetData.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                
                print("verifierUserSetData --> \(response)")
                print("verifierUserSetData PARAMS--> \(parameters)")
                switch (response.result) {
                    
                case .success(_):
                    
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200
                    {
                        closure(.success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(.failed(String(code)))
                        }else{
                            closure(.failed(""))
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    closure(.serverError(encodingError.localizedDescription))
                }
        }
        
    }
    
    
    //MARK: - Login
    
    func verifierLogin(parameters: [String: Any], closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domainv2 + UrlLink.verifierLogin.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("Lets login \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierLogin ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - LoginFB
    
    func verifierLoginFB(parameters: [String: Any], closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domainv2 + UrlLink.verifierLoginFB.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("Lets login FB \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierLoginFB ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - LoginVK
    
    func verifierLoginVK(parameters: [String: Any], closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domainv2 + UrlLink.verifierLoginVK.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("Lets login VK \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierLoginFB ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - ResetPassword
    
    func verifierResetPassword(parameters: [String: Any], closure: @escaping (String?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        print("TOKEN \(resultRealm.first?.enterToken ?? "")")
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domain + UrlLink.passReset.getUrlLink())
        print("URL \(url!)")
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierResetPassword ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - ChangePassword
    
    func verifierChangePassword(parameters: [String: Any], closure: @escaping (String?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domainv2 + UrlLink.changepassword.getUrlLink())
        print("URL \(url!)")
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierResetPassword ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
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
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domain + UrlLink.resendVerifierEmail.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - ResendVerifierEmail
    
    func checkVerifierEmail(parameters: [String: Any], closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domainv2 + UrlLink.checkVerifierEmail.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("checkVerifierEmail ---> url \(self.domainv2 + UrlLink.checkVerifierEmail.getUrlLink()) params \(parameters)")
        
        sessionManager.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("checkVerifierEmail RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("checkVerifierEmail ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil,.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - ResendVerifierEmail
    
    func checkToken(closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domainv2 + UrlLink.checkToken.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("checkToken ---> url \(self.domainv2 + UrlLink.checkToken.getUrlLink())")
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("checkToken RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("checkToken ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                     statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
//                         closure(nil, .serverError("401"))
                    } else {
                        closure(nil,.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Logout
    
    func verifierLogout(closure:  @escaping (ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domain + UrlLink.verifierLogout.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //ChatBranch
    
    func branchChat(branch: String, closure: @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domainv2 + UrlLink.chatBranch.getUrlLink() + branch)
        print("branchChat url ---> \(String(describing: url))")
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding:  URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("branchChat ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String: Any]]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("branchChat ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //FIXME: - Для чего?
    
    func push(parameters: [String: Any], closure: @escaping (ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domain + UrlLink.push.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
    
    func verifierRegistration(parameters: [String: Any], closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = URL(string: self.domainv2 + UrlLink.verifierRegistration.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("verifierRegistration ---> url \(self.domainv2 + UrlLink.verifierRegistration.getUrlLink()) params \(parameters)")
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("verifierRegistration ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]
                    {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("verifierRegistration ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Update
    
    func verifierUpdate(parameters: [String: Any], closure: @escaping (ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domainv2 + UrlLink.verifierUpdate.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .post, parameters: parameters, encoding:  JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                
                
            print("verifierUpdate --> \(response)")
            print("verifierUpdate HEADER--> \(headers)")
            print("verifierUpdate PARAMS--> \(parameters)")
            switch (response.result) {
                
            case .success(_):
                
                if let res = response.result.value as? [String: AnyObject],
                    let statusCode = res["statusCode"] as? Int, statusCode == 200
                {
                    closure(.success)
                } else {
                    if let res = response.result.value as? [String: AnyObject],
                        let code = res["code"] as? Int {
                        closure(.failed(String(code)))
                    }else{
                        closure(.failed(""))
                    }
                    
                }
                
            case .failure(let encodingError):
                closure(.serverError(encodingError.localizedDescription))
            }
        }
        
    }
    
    
    //MARK: - Get User
    
    func getVerifierUser(closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        print("getVerifierUser TOKEN ---> \(token)")
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.verifierUser.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getVerifierUser URL ---> \(String(describing: url))")
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getVerifierUser RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any] {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getVerifierUser ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.reloginUser()
                        
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                    
                }
        }
    }
    
    
    //MARK: - Get Contract List
    
    func getUserDocumentsList(closure:  @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        print("userDocumentList TOKEN ---> \(token)")
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.userDocumentsList.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("userDocumentList URL ---> \(String(describing: url))")
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("userDocumentList RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String: Any]] {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("userDocumentList ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                        
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                    
                }
        }
    }
    
    //MARK: - Download Contract
    func getUserDocumentDownload(documentId:Int, documentType: String, closure:  @escaping (URL?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let params = ["documentId" : Int64(documentId), "documentType" : documentType] as [String : Any]
        
        let token = resultRealm.first?.enterToken ?? ""
        print("userDocumentDownload TOKEN ---> \(token)")
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.userDocumentDownload.getUrlLink())
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("pdfdocument.pdf")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        print("userDocumentDownload URL ---> \(String(describing: url))")
        
        Alamofire.download(url!, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers, to: destination).response{ response in
                if response.error == nil, let _ = response.destinationURL?.path    {
                    print("FILEPATH \(String(describing: response.destinationURL))")
                 
                            closure(response.destinationURL, .success)
                    
                }
            }
        
        
    }
   
    
  
    //MARK: - ORDER FEED
    
    
    func getOrderFeed(start: Int, count: Int, closure:  @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        
        //PARAMS FILTER
        var filter = resultFilterRealm.first
        
        if filter == nil {
            RealmSwiftFilterAction.resetToDefault()
            filter = resultFilterRealm.first
        }
        
        
        
        var params = [String: Any]()
        
       
        if let priceOrder = filter?.priceOrder, priceOrder.count > 0 {
            params["priceOrder"] = String(priceOrder)
        }
        
        if let dist = filter?.dist {
            params["dist"] = Int32(dist)
        }
        
        if let orderTypeId = filter?.orderTypeId {
            params["orderTypeId"] = Int64(orderTypeId)
        }
        
        if let orderLevel = filter?.orderLevel.value {
            params["orderLevel"] = Int(orderLevel)
        }
        
        if let verifTimeTo = filter?.verifTimeTo.value{
            params["verifTimeTo"] = Int(verifTimeTo)
        }
        
        if let available = filter?.available {
            if available != false {
                    params["available"] = Bool(available)
            }
            
        }
        
        params["count"] = Int32(count)
        params["start"] = Int32(start)
        
        
        print ("getOrderFeed PARAMS ---> \(params)")
        //
        
        
        
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.orderFeed.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getOrderFeed URL ---> \(String(describing: url))")
        sessionManager.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getOrderFeed RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String: Any]] {
                        print ("getOrderFeed COUNT ---> \(data.count)")
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getOrderFeed ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.reloginUser()
                        
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }

    
    
    //MARK: - GET ORDER
    
    func getOrder(id: String, closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.order.getUrlLink() + id)
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getOrder RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any] {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getOrder ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - GET ORDER
    
    func getOrderStep(id: String, closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.orderStep.getUrlLink() + id)
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getOrderStep URL ---> \(String(describing: url))")
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getOrderStep RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any] {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getOrderStep ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - GET ORDER
    
    func getOrderStepList(id: String, closure:  @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.orderStepList.getUrlLink() + id)
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getOrderStepList URL ---> \(String(describing: url))")
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getOrderStepList RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String: Any]] {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getOrderStep ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - GETAccept
    
    func orderAccept(id: String, closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.orderAccept.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("orderAccept URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .post, parameters: ["orderId" : id], encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("orderAccept RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200 {
                        closure(nil, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("orderAccept ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - MY ORDER FEED
    
    
    func getMyOrderFeed(status: String, closure:  @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.myOrderFeed.getUrlLink() + status + "/0/0")
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getMyOrderFeed URL ---> \(String(describing: url))")
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getMyOrderFeed RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String: Any]] {
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getMyOrderFeed ---> " + error.localizedDescription)
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.reloginUser()
                        
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Order Step Set Data
    
    func orderStepData(params: [String : Any], closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.orderStepData.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("orderStepData URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("orderStepData RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String: Any]{
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("orderStepData ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Order Rate
    
    func orderRate(params: [String : Any], closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.orderRate.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("orderStepData URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("orderStepData RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200{
                        closure(nil, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("orderStepData ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - GET BADGES
    
    func getBadges(closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.getBadges.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getBadges URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getBadges RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                    let data = res["data"] as? [String : Any]{
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getBadges ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }

    
    //MARK: - NOTIFICATION
    
    func notificationList(start:Int, count: Int, closure:  @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.notificationList.getUrlLink() + String(start) + "/" + String(count))
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("notificationList URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("notificationList RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String : Any]]{
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("notificationList ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Notification Read
    
    func notificationRead(params: [String : Any], closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        print("notificationRead PARAMS ---> \(params)")
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.notificationRead.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("notificationRead URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("notificationRead RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200{
                        closure(nil, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("notificationRead ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Notification Read
    
    func notificationAllRead(closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.notificationAllRead.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("notificationAllRead URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("notificationAllRead RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200{
                        closure(nil, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("notificationAllRead ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    //MARK: - Attach File
    func attachFile(with image: UIImage, closure:  @escaping (ServerResponse<(Int, String)>) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let url = URL(string: domain + UrlLink.verifierUpload.getUrlLink())
        print("URL UPLOAD \(url!)")
        let configuration = URLSessionConfiguration.default
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        var requestUrl = try! URLRequest(url: url!, method: .post, headers: headers)
        requestUrl.timeoutInterval = 99999
        
        do {
            let encodedURLRequest = try URLEncoding.queryString.encode(requestUrl, with: nil)
            
            let sessionManager = Alamofire.SessionManager(configuration: configuration)
            let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
            sessionManager.retrier = requestRetrier        // Set the retrier
            
            sessionManager.upload(multipartFormData: { multipartFormData in
                
                //for image in images {
               
                let imageData = InternalHelper.sharedInstance.normalizedImage(img: image).jpegData(compressionQuality: 0.75)
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
                            print("PHOTOLINK \(data["link"] ?? "")")
                            closure(.success((0, link)))
                        } else {
                            if let statusCode = (response.response?.statusCode),
                                statusCode == 401 {
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
    
    func attachFile(video: Data, closure:  @escaping (ServerResponse<(Int, String)>) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let url = URL(string: domain + UrlLink.verifierUpload.getUrlLink())
        print("URL UPLOAD \(url!)")
        let configuration = URLSessionConfiguration.default
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        var requestUrl = try! URLRequest(url: url!, method: .post, headers: headers)
        requestUrl.timeoutInterval = 99999
        
        do {
            let encodedURLRequest = try URLEncoding.queryString.encode(requestUrl, with: nil)
            
            let sessionManager = Alamofire.SessionManager(configuration: configuration)
            let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
            sessionManager.retrier = requestRetrier        // Set the retrier
            
            sessionManager.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(video, withName: "file", fileName: "\(self.timestamp)_video.mov", mimeType: "video/*")
                
            }, with: encodedURLRequest, encodingCompletion: { encodingResult in
                
                print("attachFileVideo encodingResult ---> \(encodingResult)" )
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        sessionManager.session.invalidateAndCancel()
                        print("attachFileVideo response ---> \(response)" )
                        if let res = response.result.value as? [String: AnyObject],
                            let statusCode = res["statusCode"] as? Int, statusCode == 200,
                            let data = res["data"] as? [String: String], let link = data["link"] {
                            print("VIDEOLINK \(data["link"] ?? "")")
                            closure(.success((0, link)))
                        } else {
                            
                            if let statusCode = (response.response?.statusCode),
                                statusCode == 401 {
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
    
    
    //MARK: - Filter
    
    
    //MARK: - getOrderFilterData
    
    func getOrderFilterData(closure:  @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domainv2 + UrlLink.getOrderFilterData.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getOrderFilterData URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getOrderFilterData RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [String : Any]{
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getOrderFilterData ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    //MARK: - Filter get Content List
    
    func getContentList(closure:  @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.getContentList.getUrlLink())
        
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        print("getContentList URL ---> \(String(describing: url))")
        
        sessionManager.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                sessionManager.session.invalidateAndCancel()
                print("getContentList RESPONSE ---> \(response)")
                switch (response.result) {
                case .success(_):
                    if let res = response.result.value as? [String: AnyObject],
                        let statusCode = res["statusCode"] as? Int, statusCode == 200,
                        let data = res["data"] as? [[String : Any]]{
                        closure(data, .success)
                    } else {
                        if let res = response.result.value as? [String: AnyObject],
                            let code = res["code"] as? Int {
                            closure(nil, .failed(String(code)))
                        }else{
                            closure(nil, .failed(""))
                        }
                        
                    }
                    break
                case .failure(let error):
                    print("getContentList ---> " + error.localizedDescription)
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .serverError(error.localizedDescription))
                    }
                }
        }
    }
    
    
    
    
    //MARK: - Send Feedback
    
    func sendFeedBack(name: String, text: String, closure: @escaping ([String: AnyObject]?, ResponseResult) -> Void) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let token = resultRealm.first?.enterToken ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": token]
        let url = URL(string: self.domain + UrlLink.sendFeedback.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
        let parameters = [
            "feedbackName": name,
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
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(nil, .failed(error.localizedDescription))
                        
                    }
                }
        }
    }
    
    
   
    
    //MARK: - Other
    
    private func normalizedImage(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage;
    }
    
    
  
    //FIXME: - Не используется
    //MARK: - Verify
    
    func verifierVerify(verifAddr: String,
                        long: Double,
                        lat: Double,
                        timeTo: Int,
                        closure:  @escaping (ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(.noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Token": resultRealm.first?.enterToken ?? ""]
        let url = URL(string: self.domain + UrlLink.verify.getUrlLink())
        let sessionManager = self.getSessionManager(url: url!)
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                    
                    if let statusCode = (response.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError(error.localizedDescription))
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
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                    
                    if let statusCode = ($0.response?.statusCode),
                        statusCode == 401 {
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
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        sessionManager.retrier = requestRetrier        // Set the retrier
        
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
                    
                    if let statusCode = ($0.response?.statusCode),
                        statusCode == 401 {
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.reloginUser()
                    } else {
                        closure(.serverError)
                    }
                }
        }
    }
    
    class NetworkRequestRetrier: RequestRetrier {
        
        // [Request url: Number of times retried]
        private var retriedRequests: [String: Int] = [:]
        
        internal func should(_ manager: SessionManager,
                             retry request: Request,
                             with error: Error,
                             completion: @escaping RequestRetryCompletion) {
            
            guard
                request.task?.response == nil,
                let url = request.request?.url?.absoluteString
                else {
                    removeCachedUrlRequest(url: request.request?.url?.absoluteString)
                    completion(false, 0.0) // don't retry
                    return
            }
            
            guard let retryCount = retriedRequests[url] else {
                retriedRequests[url] = 1
                print("RETRYREQUEST")
                completion(true, 1.0) // retry after 1 second
                return
            }
            
            if retryCount <= 3 {
                retriedRequests[url] = retryCount + 1
                print("RETRYREQUEST")
                completion(true, 1.0) // retry after 1 second
            } else {
                removeCachedUrlRequest(url: url)
                print("RETRYREQUEST")
                completion(false, 0.0) // don't retry
            }
            
        }
        
        private func removeCachedUrlRequest(url: String?) {
            guard let url = url else {
                return
            }
            retriedRequests.removeValue(forKey: url)
        }
        
    }
}
