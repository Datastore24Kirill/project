//
//  StepField.swift
//  Verifier_new
//
//  Created by Nekich_Pekich on 3/11/19.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class StepField {
    var fieldData:                          String?
    var fieldDescription:                   String?
    var fieldId                             = 0
    var fieldName:                          String?
    var fieldRequired                       = false
    var fieldType:                          FieldTypeEnum
    var fieldUnderNoList: [FieldUnder]      = []
    var fieldUnderYesList: [FieldUnder]     = []
    var isAnswerYes:                        Bool?
    var answerImage:                        UIImage?
    var answerVideoURL:                     URL?
    var answerText:                         String? = ""
    var answerMark:                         Double?
    var answerImageLink:                    String?
    var answerVideoLink:                    String?
    var answerVideoImage:                   UIImage?
    
    init(data: [String: Any]) {
        self.fieldData          = data["fieldData"]         as? String
        self.fieldDescription   = data["fieldDescription"]  as? String
        self.fieldId            = data["fieldId"]           as! Int
        self.fieldName          = data["fieldName"]         as? String
        if let required         = data["fieldRequired"]     as? Bool {
            self.fieldRequired  = required
        }
        self.fieldType          = FieldTypeEnum.getFieldTypeEnum(fieldTypeString: (data["fieldType"] as! String))
        if fieldType == .check {
            if let underNoList  = data["fieldUnderNo"]      as? [[String:Any]] {
                underNoList.forEach {
                    let field   = FieldUnder.init(data: $0)
                    self.fieldUnderNoList.append(field)
                }
            }
            if let underYesList = data["fieldUnderYes"]     as? [[String:Any]] {
                underYesList.forEach {
                    let field   = FieldUnder.init(data: $0)
                    self.fieldUnderYesList.append(field)
                }
            }
        }
    }
    func validate(fieldType: FieldTypeEnum) -> Bool {
        if !fieldRequired {
            return true
        }
        else {
            switch fieldType {
            case .text:
                return answerText != nil && answerText != ""
            case .photo:
                return answerImageLink != nil
            case .video:
                return answerVideoLink != nil
            case .mark:
                return answerMark != nil
            case .check:
                var isValid = true
                if let answer = isAnswerYes {
                    if answer {
                        fieldUnderYesList.forEach {
                            if !$0.validate(fieldType: $0.fieldType) {
                                isValid = false
                            }
                        }
                    }
                    else {
                        fieldUnderNoList.forEach {
                            if !$0.validate(fieldType: $0.fieldType) {
                                isValid = false
                            }
                        }
                    }
                }
                else {
                    return false
                }
                return isValid
                
            }
        }
    }
}
