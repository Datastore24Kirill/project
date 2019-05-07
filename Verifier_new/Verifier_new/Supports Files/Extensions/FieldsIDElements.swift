//
//  FieldsIDElements.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/01/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import Cosmos

class verifierUIButton: UIButton {
    var fieldId: Int?
    var fieldRequired: Bool?
}

class verifierUIView: UIView {
    var fieldId: Int?
    var fieldRequired: Bool?
}

class verifierUITextView: UITextView {
    var fieldId: Int?
    var fieldRequired: Bool?
}

class verifierUISegmentedControl: UISegmentedControl {
    var fieldId: Int?
    var fieldRequired: Bool?
    var fieldUnderNo: [[String:Any]]?
    var fieldUnderYes: [[String:Any]]?
    var fieldIndexPath: IndexPath?
    var indexPath: IndexPath?
    var section: Int?
    var isAnswerYes: Bool?
}

class verifierCosmosView: CosmosView {
    var fieldId: Int?
    var fieldRequired: Bool?
    var indexPath: IndexPath?
    var section: Int?
}

class verifierUIImageView: UIImageView {
    var fieldId: Int?
    var fieldRequired: Bool?
    var fieldLink: String?
}

class verifierUIImagePickerController: UIImagePickerController {
    var fieldId:    Int?
    var isPhoto:    Bool?
    var indexPath:  IndexPath?
    var section:    Int?
}


