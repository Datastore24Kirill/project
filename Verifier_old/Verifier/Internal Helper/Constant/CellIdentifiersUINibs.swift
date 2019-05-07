//
//  CellIdentifiersUINibs.swift
//  Verifier
//
//  Created by Mac on 16.02.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class CellIdentifiersUINibs: NSObject {
    
    enum Indentifiers: String {
        case personalCell = "PersonalProfileCollectionViewCell"
        case idDataCell = "IdDataCollectionViewCell"
        case addressCell = "AddressProfileCollectionViewCell"
        case emailCell = "EmailCollectionViewCell"
        case verifyCell = "VerifyCollectionViewCell"
        
        //Filter
        case filterRangeOfOrderExecutionViewCell = "FilterRangeOfOrderExecutionViewCell"
        case filterMapTableViewCell = "FilterMapTableViewCell"
        case filterRadiusTableViewCell = "FilterRadiusTableViewCell"
        case filterContentTableViewCell = "FilterContentTableViewCell"
    }
    
}
