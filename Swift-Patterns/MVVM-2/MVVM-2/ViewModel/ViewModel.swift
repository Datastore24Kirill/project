//
//  ViewModel.swift
//  MVVM-2
//
//  Created by Кирилл Ковыршин on 13/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import Foundation



class ViewModel: TableViewViewModelType {

    var profiles = [ProfileModel(name: "Kirill", secondName: "Kovyrshin", age: 32),
                    ProfileModel(name: "Anna", secondName: "Kovyrshina", age: 23),
                    ProfileModel(name: "Slavik", secondName: "Kovyrshin", age: 2),
                    ProfileModel(name: "Klim", secondName: "Kovyrshin", age: 5),
                    ProfileModel(name: "Dasha", secondName: "Kovyrshina", age: 10)]
    
  
    func numberOfRows() -> Int {
        return profiles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let profile = profiles[indexPath.row]
        return TableViewCellViewModel(profileModel: profile)
    }
    
    
}
