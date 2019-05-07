//
//  FieldType.swift
//  Verifier_new
//
//  Created by Nekich_Pekich on 3/11/19.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

enum FieldTypeEnum {
    case text, photo, video, check, mark
    var fieldType: String {
        switch self {
        case .text:
            return "TXT"
        case .photo:
            return "PHOTO"
        case .video:
            return "VIDEO"
        case .check:
            return "CHECK"
        case .mark:
            return "MARK"
        }
    }
    static func getFieldTypeEnum(fieldTypeString: String) -> FieldTypeEnum {
        switch fieldTypeString {
        case "TXT":
            return .text
        case "PHOTO":
            return .photo
        case "VIDEO":
            return .video
        case "CHECK":
            return .check
        case "MARK":
            return .mark
        default:
            return .text
        }
    }
    
}

