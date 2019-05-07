//
//  TaskStepListDB.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 22/04/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//


import Foundation
import RealmSwift
class TaskStepListDB: Object {
    @objc dynamic var compoundKey: Int = 0
    @objc dynamic var taskId: Int = 0
    @objc dynamic var taskStepIndex: Int = 0
    @objc dynamic var taskStep: String? = nil
    @objc dynamic var isSendToTheServer = false
    @objc dynamic var needSendToTheServer = false
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    
}

struct RealmSwiftTaskStepListAction {
    
    static func updateRealm(taskId: String?, taskStepIndex: String?, taskStep: String?, isSendToTheServer: Bool?, needSendToTheServer: Bool?) {
        let realm = try! Realm()
        
        
        try? realm.write {
            
            var dict : [String : Any] = ["taskId" : 1]
            
            if taskId != nil && taskStepIndex != nil {
                let compoundKey = "\(taskId!)\(taskStepIndex!)"
                dict["compoundKey"] = Int(compoundKey)
            }
            
            if taskId != nil {dict["taskId"] = Int(taskId!)}
            if taskStepIndex != nil {dict["taskStepIndex"] = Int(taskStepIndex!)}
            
           
            
            if taskStep != nil { dict["taskStep"] = taskStep }
            if isSendToTheServer != nil { dict["isSendToTheServer"] = isSendToTheServer! }
            if needSendToTheServer != nil { dict["needSendToTheServer"] = needSendToTheServer! }
            
            print("TasksDB \(dict)")
            
            realm.create(TaskStepListDB.self, value: dict, update: true)
        }
        
        
        
        
        
    }
    
    static func listRealm() -> Results<TaskStepListDB> {
        //        let results : Results<RealmDB>!
        // Query using a predicate string
        let realm = try! Realm()
        let result = realm.objects(TaskStepListDB.self)
        
        return result
        
    }
    
    
}


