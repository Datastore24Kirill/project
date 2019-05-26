//
//  ViewModel.swift
//  MVVM-1
//
//  Created by Кирилл Ковыршин on 13/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation

class ViewModel {
    private var profile = Profile(name: "Kirill", secondName: "Kovyrshin", age: 32)
    
    var name: String {
        return profile.name
    }
    
    var secondName: String {
        return profile.secondName
    }
    
    var age: String {
        return String(profile.age)
    }
}
