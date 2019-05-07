//
//  StepModel.swift
//  Verifier_new
//
//  Created by Nekich_Pekich on 3/11/19.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class StepModel {
    var stepId                  = 0
    var stepIndex               = 0
    var stepCount               = 0
    var stepInfo:               String?
    var stepName:               String?
    var stepFields: [StepField] = []
    var stepFieldArray: [[String:Any]] = []
    
    init(data: [String: Any]) {
        self.stepId      = data["stepId"]               as! Int
        self.stepIndex   = data["stepIndex"]            as! Int
//        self.stepCount   = data["stepsCount"]           as! Int
        self.stepInfo    = data["stepInfo"]             as? String
        self.stepName    = data["stepName"]             as? String
        if let stepFieldArray = data["stepFields"] as? [[String:Any]] {
            stepFieldArray.forEach {
                let stepField = StepField(data: $0)
                self.stepFields.append(stepField)
            }
        }
        
    }
    func setInfo() -> [String: Any] {
        var params: [String:Any] = [:]
        stepFieldArray.removeAll()
        
        stepFields.forEach {
            if let dict = getInfoFromField(fieldUnder: $0) {
                stepFieldArray.append(dict)
            }
        }
        params["stepFields"] = stepFieldArray
        return params
    }
    func getInfoFromField(fieldUnder: StepField) -> [String: Any]? {
        switch fieldUnder.fieldType {
        case .text:
            if fieldUnder.answerText != nil {
                var stepDict: [String:Any] = [:]
                stepDict["fieldId"] = fieldUnder.fieldId
                stepDict["fieldData"] = fieldUnder.answerText
                return stepDict
            }
        case .photo:
            if fieldUnder.answerImageLink != nil {
                var stepDict: [String:Any] = [:]
                stepDict["fieldId"] = fieldUnder.fieldId
                stepDict["fieldData"] = fieldUnder.answerImageLink
                return stepDict
            }
        case .video:
            if fieldUnder.answerVideoLink != nil {
                var stepDict: [String:Any] = [:]
                stepDict["fieldId"] = fieldUnder.fieldId
                stepDict["fieldData"] = fieldUnder.answerVideoLink
                return stepDict
            }
        case .mark:
            if fieldUnder.answerMark != nil {
                var stepDict: [String:Any] = [:]
                stepDict["fieldId"] = fieldUnder.fieldId
                stepDict["fieldData"] = fieldUnder.answerMark
                return stepDict
            }
        case .check:
            if fieldUnder.isAnswerYes != nil {
                if fieldUnder.isAnswerYes! {
                    for field in fieldUnder.fieldUnderYesList {
                        if let info = getInfoFromField(fieldUnder: field) {
                            stepFieldArray.append(info)
                        }
                    }
                    var stepDict: [String:Any] = [:]
                    stepDict["fieldId"] = fieldUnder.fieldId
                    stepDict["fieldData"] = "true"
                    return stepDict
                    
                }
                else {
                    for field in fieldUnder.fieldUnderNoList {
                        if let info = getInfoFromField(fieldUnder: field) {
                            stepFieldArray.append(info)
                        }
                    }
                    var stepDict: [String:Any] = [:]
                    stepDict["fieldId"] = fieldUnder.fieldId
                    stepDict["fieldData"] = "false"
                    return stepDict
                }
            }
        }
        return nil
    }
    
    func getInfoFromCheckField(fieldUnder: FieldUnder) {
        if fieldUnder.isAnswerYes != nil {
            if fieldUnder.isAnswerYes! {
                var stepDict: [String:Any] = [:]
                stepDict["fieldId"] = fieldUnder.fieldId
                stepDict["fieldData"] = "true"
                stepFieldArray.append(stepDict)
            }
            else {
                var stepDict: [String:Any] = [:]
                stepDict["fieldId"] = fieldUnder.fieldId
                stepDict["fieldData"] = "false"
                stepFieldArray.append(stepDict)
            }
        }
    }
    
//
}
