//
//  TableViewCellViewModel.swift
//  MVVM-2
//
//  Created by Кирилл Ковыршин on 14/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    private var profileModel: ProfileModel
    
    var fullName: String {
        return profileModel.secondName + " " + profileModel.name
    }
    
    var age: String {
        return String(profileModel.age)
    }
    
    init(profileModel: ProfileModel) {
        self.profileModel = profileModel
    }
}
