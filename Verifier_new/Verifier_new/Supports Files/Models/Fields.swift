//
//  Fields.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 28/11/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import Foundation
import UIKit

struct Field {
    var label = ""
    var type = ""
    var name = ""
    var minCount = "1"
    var data = String()
    var photoArray = [UIImage?]()
    var videoData: Data? = nil
}
