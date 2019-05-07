//
//  FilterDB.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import RealmSwift
class FilterDB: Object {
    @objc dynamic var id = 1
    @objc dynamic var priceOrder: String? = nil
    @objc dynamic var dist = Int32(10)
    @objc dynamic var orderTypeId = Int64(0)
                  var orderLevel = RealmOptional<Int>()
                  var verifTimeTo = RealmOptional<Int>()
    @objc dynamic var available = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

struct RealmSwiftFilterAction {
    
    static func updateRealm(priceOrder: String?, dist: Int32?, orderTypeId: Int64?,
                            orderLevel: Int?, verifTimeTo: Int?, available: Bool?) {
        let realm = try! Realm()
        
        try? realm.write {
            
            var dict : [String : Any] = ["id" : 1]
            
            
            if priceOrder != nil {dict["priceOrder"] = priceOrder!}
            if dist != nil { dict["dist"] = dist! }
            if orderTypeId != nil { dict["orderTypeId"] = orderTypeId! }
            if orderLevel != nil { dict["orderLevel"] = orderLevel! }
            if verifTimeTo != nil { dict["verifTimeTo"] = verifTimeTo! }
            if available != nil { dict["available"] = available! }
            print("DICT \(dict)")
            
            realm.create(FilterDB.self, value: dict, update: true)
        }

    }
    
    static func resetToDefault() {
        let realm = try! Realm()
        
        try? realm.write {
            
            var dict : [String : Any] = ["id" : 1]
            
            dict["priceOrder"] = ""
            dict["dist"] = 10
            dict["orderTypeId"] = 0
            dict["orderLevel"] = 0
            dict["verifTimeTo"] = 3
            dict["available"] = false
            print("DICT \(dict)")
            
            realm.create(FilterDB.self, value: dict, update: true)
        }
    }
    
    static func listRealm() -> Results<FilterDB> {
        //        let results : Results<RealmDB>!
        // Query using a predicate string
        let realm = try! Realm()
        let result = realm.objects(FilterDB.self).filter("id = 1")
        print(result)
        return result
        
    }
    
    
}
