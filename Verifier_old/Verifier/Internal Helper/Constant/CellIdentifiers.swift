//
//  CellIdentifiers.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import Foundation

class CellIdentifiers: NSObject {
    
    enum Indentifiers: String {
        case dashboardCell = "DashboardCell"
        case taskPhotoCell = "TaskPhotoCell"
        case addNewPhotoCell = "AddNewPhotoCell"
        case photoTableViewCell = "PhotoTableViewCell"
        case videoTableViewCell = "VideoTableViewCell"
        case fieldTableViewCell = "FieldTableViewCell"
        case checkTableViewCell = "CheckTableViewCell"
        case taskCell = "TaskCell"
        case loginCell = "LoginCell"
        case userInfoCell = "UserInfoCell"
        case passportCell = "PassportCell"
        case issueCell = "IssueCell"
        case userPhotoCell = "UserPhotoCell"
        
        case emailCell = "EmailCell"
        case idDataCell = "IdDataCell"
        case addressCell = "AddressCell"
        case personalCell = "PersonalCell"
        case verifyCell = "VerifyCell"
        
        //Filter
        case filterHeaderCell = "FilterHeaderCell"
        
        //Filter place list
        case filterPlaceCell = "FilterPlaceCell"
    }
    
}
