//
//  TaskStepTableModel.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 23/04/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation
import RealmSwift

protocol TaskStepTableViewControllerDelegate: class {
    func showAlertError(with title: String?, message: String?)
    func hideSpinnerView()
    func updateInformationStep(data: Results<TaskStepListDB>)
    func updateInformationTask(data: String)
    
}


class TaskStepTableModel {
    
    //MARK: - DELEGATE
    weak var delegate: TaskStepTableViewControllerDelegate?
    
    //MARK: - Properties
    let resultTaskStepRealm = RealmSwiftTaskStepListAction.listRealm()
    let resultTaskRealm = RealmSwiftTaskAction.listRealm()
    
    func getTaskInformation(orderId: Int) {
        let orderInfo = resultTaskRealm.filter("id = \(orderId)").first
        if orderInfo?.id != nil, let taskInfo = orderInfo?.taskInformation {
            delegate?.updateInformationTask(data: taskInfo)
        }
    }
    
    func getTaskSteps(orderId: Int) {
        let taskStep = resultTaskStepRealm.filter("taskId = \(orderId)").sorted(byKeyPath: "taskStepIndex")
        if taskStep.count > 0 {
            delegate?.updateInformationStep(data: taskStep)
        }
    }

}
