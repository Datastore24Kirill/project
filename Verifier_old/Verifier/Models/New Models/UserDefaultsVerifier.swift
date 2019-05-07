//
//  UserDefautsCustom.swift
//  Verifier
//
//  Created by Mac on 02.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

struct UserDefaultsVerifier {
    
    static let userDefaults = UserDefaults.standard
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    private init() {}
    
    
    
    static func getUser() -> User? {
        
        var user: User?
        if let data = UserDefaults.standard.value(forKey:"User") as? Data {
            user = try? decoder.decode(User.self, from: data)
        }
        
        return user
    }
    
    static func saveUser(with user: User) {
        let data = try? encoder.encode(user)
        userDefaults.set(data, forKey:"User")
    }
    
    static func deleteUser() {
        userDefaults.removeObject(forKey:"User")
    }
    
    static func setToken(with token: String) {
        var user = getUser() ?? User()
        print("TOKETOSAVE \(token)")
        user.token = token
        print("USERTOSAVE \(user)")
        saveUser(with: user)
    }
    
    static func setPushToken(with token: String) {
        
        var user = getUser() ?? User()
        print("TOKETOSAVE \(token)")
        user.pushToken = token
         print("USERTOSAVE \(user)")
        saveUser(with: user)
    }
    
    static func setIsPromoViewed(with bool: String) {
        
        var user = getUser() ?? User()
        user.isPromoViewed = bool
        
        saveUser(with: user)
        
        if let userInfo = UserDefaultsVerifier.getUser() {
            print("USERTOSAVE \(userInfo)")
        }
    }
    
    static func setTokenWithSocial(with token: String, social: String?) {
        var user = User()
        user.token = token
        user.social = social
        
        saveUser(with: user)
    }
    
    static func setNameAndLastName() {
        guard var user = getUser() else {
            return
        }
        
        if let value = User.sharedInstanse.firstName {
            user.firstName = value
        }
        
        if let value = User.sharedInstanse.lastName {
            user.lastName = value
        }
        
        saveUser(with: user)
        
    }
    
    static func deleteEmailAndPassword() {
        
        guard var user = getUser() else {
            return
        }
        
        if let value = User.sharedInstanse.email {
            user.email = value
        }
        
        user.password = nil
        user.repeatPassword = nil
        saveUser(with: user)
    }
    
    static func deletePassword() {
        
        guard var user = getUser() else {
            return
        }
        
        user.password = nil
        user.repeatPassword = nil
        saveUser(with: user)
    }
    
    static func getToken() -> String {
        guard let data = UserDefaults.standard.value(forKey:"User") as? Data else {
            return ""
        }
        if let user = try? decoder.decode(User.self, from: data) {
            
            return user.token ?? ""
        }
        return ""
    }
    
    static func getPushToken() -> String {
        
        guard let data = UserDefaults.standard.value(forKey:"User") as? Data else {
            return ""
        }
        if let user = try? decoder.decode(User.self, from: data) {
            print("TOKETOGET \(user)")
        
            return user.pushToken ?? ""
        }
        return ""
    }
    
    static func getIsPromoViewed() -> Bool {
        
        guard let data = UserDefaults.standard.value(forKey:"User") as? Data else {
            return false
        }
        if let user = try? decoder.decode(User.self, from: data) {
            print("ISPROMOVIEWED \(user)")
            if let bool = user.isPromoViewed {
                return Bool(bool) ?? false
            }
            return false
        }
        return false
    }
    
}

//MARK: Filter
extension UserDefaultsVerifier {
    
    static func getFilterParameters() -> User.Filter? {
        guard let filter = getUser()?.filter else {
            guard let coordinate = LocationManager.share.currentLocation else {
                return nil
            }
            let filter = User.Filter(
                rangeOfOrderExecution: nil,
                address: Place(cor: coordinate, name: ""),
                radius: Constants.defaultRadius,
                content: nil
            )
            return filter
        }
        return filter
    }
    
    static func setFilterParameters(with parameters: User.Filter) {
        guard var user = getUser() else {
            return
        }

        var filter = user.filter ?? User.Filter()

        if let value = parameters.address {
            filter.address = value
        }

        if let value = parameters.content {
            filter.content = value
        }

        if let value = parameters.radius {
            filter.radius = value
        } else {
            filter.radius = Constants.defaultRadius
        }

        if let value = parameters.rangeOfOrderExecution {
            filter.rangeOfOrderExecution = value
        }

        user.filter = filter
        saveUser(with: user)
    }
}
