//
//  TasksDB.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 04/04/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import RealmSwift
class TasksDB: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var taskInformation: String? = nil
    @objc dynamic var isSendToTheServer = false
    @objc dynamic var needSendToTheServer = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

struct RealmSwiftTaskAction {
    
    static func updateRealm(id: String?, taskInformation: String?, isSendToTheServer: Bool?, needSendToTheServer: Bool?) {
        let realm = try! Realm()
        
       
       
        
        
        try? realm.write {
            
            var dict : [String : Any] = ["id" : 1]
            
            
            if id != nil {dict["id"] = Int(id!)}
            if taskInformation != nil { dict["taskInformation"] = taskInformation }
            if needSendToTheServer != nil { dict["needSendToTheServer"] = needSendToTheServer! }
            if isSendToTheServer != nil { dict["isSendToTheServer"] = isSendToTheServer! }
            
            print("TasksDB \(dict)")
            
            realm.create(TasksDB.self, value: dict, update: true)
        }
        
        
        
        
        
    }
    
    static func listRealm() -> Results<TasksDB> {
        //        let results : Results<RealmDB>!
        // Query using a predicate string
        let realm = try! Realm()
        let result = realm.objects(TasksDB.self)
        
        return result
        
    }
    
    
}


