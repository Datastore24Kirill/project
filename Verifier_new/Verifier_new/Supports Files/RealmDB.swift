//
//  RealmDB.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 11/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import RealmSwift
class RealmDB: Object {
    @objc dynamic var id = 1
    @objc dynamic var verifierId: String? = nil
    @objc dynamic var enterToken: String? = nil
    @objc dynamic var pushToken: String? = nil
    @objc dynamic var isFirstLaunch = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

struct RealmSwiftAction {
    
    static func updateRealm(verifierId: String?, enterToken: String?, pushToken: String?, isFirstLaunch: Bool?) {
        let realm = try! Realm()
 
        try? realm.write {
            
             var dict : [String : Any] = ["id" : 1]
            
    
            if verifierId != nil {dict["verifierId"] = verifierId!}
            if enterToken != nil { dict["enterToken"] = enterToken! }
            if pushToken != nil { dict["pushToken"] = pushToken! }
            if isFirstLaunch != nil { dict["isFirstLaunch"] = isFirstLaunch! }
            print("DICT \(dict)")
            
            realm.create(RealmDB.self, value: dict, update: true)
        }
        
        
        

        
    }
    
    static func listRealm() -> Results<RealmDB> {
//        let results : Results<RealmDB>!
        // Query using a predicate string
        let realm = try! Realm()
        let result = realm.objects(RealmDB.self).filter("id = 1")
        
        return result
        
    }
    
    
}
