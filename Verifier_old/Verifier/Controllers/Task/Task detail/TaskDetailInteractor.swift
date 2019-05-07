//
//  TaskDetailInteractor.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol TaskDetailInteractorInput: class {
    func getTaskData(taskId: Int)
}

protocol TaskDetailInteractorOutput: class {
    func provideDataTask(success: Bool, task: Task?, error: [String: Any]?)
}

class TaskDetailInteractor: TaskDetailInteractorInput {
    
    weak var presenter: TaskDetailInteractorOutput!
    var apiRequestManager: RequestHendler!
    let decoder = JSONDecoder()
    
    struct RequestOrder: Codable {
        var data: Order
    }
    
    func getTaskData(taskId: Int) {
        
        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideDataTask(success: false, task: nil, error: ["title": "No internet connection", "message": "Check your internet connection and try again"])
            return
        }
        
        apiRequestManager.getOrder(id: taskId) { res, serverResult in
            if let data = res {
                if let requestOrder = try? self.decoder.decode(RequestOrder.self, from: data) {
                    
                    let resOrder = requestOrder.data
                    var task = Task()
                    
                    task.id = Int(taskId)
                    task.title = resOrder.orderName ?? ""
                    task.text = resOrder.orderComment
                    task.city = resOrder.verifAddr
                    task.tokens = Double(resOrder.orderRate)
                    task.rating = resOrder.orderRating
                    task.verifAddrLatitude = resOrder.verifAddrLatitude
                    task.verifAddrLongitude = resOrder.verifAddrLongitude
                    
                    var taskFields = [Field]()
                    
                    resOrder.orderFields.forEach {
                        taskFields.append(Field(
                            label: $0.fieldDescription ?? "",
                            type: $0.fieldType ?? "",
                            name: $0.fieldName ?? "",
                            minCount: $0.fieldMinCount ?? "",
                            data: String(),
                            photoArray: [],
                            videoData: nil
                        ))
                    }
                    
                    task.fileds = taskFields
                    
                    self.presenter.provideDataTask(success: true, task: task, error: nil)
                }
            }
        }
    }
}
