//
//  TableViewCellViewModelType.swift
//  MVVM-2
//
//  Created by Кирилл Ковыршин on 14/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation

protocol TableViewCellViewModelType: class {
    
    var fullName: String { get }
    var age: String { get }
}
