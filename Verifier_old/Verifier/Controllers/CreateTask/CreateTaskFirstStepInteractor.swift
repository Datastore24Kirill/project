//
//  CreateTaskFirstStepInteractor.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 01.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

protocol CreateTaskFirstStepInteractorInput: class {
    func getContentList()
}

protocol CreateTaskFirstStepInteractorOutput: class {
    func provideContentListData(result: ServerResponse<[FilterContentModel]>)
}

class CreateTaskFirstStepInteractor: CreateTaskFirstStepInteractorInput {
    
    //MARK: Properties
    weak var presenter: CreateTaskFirstStepInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func getContentList() {
        apiRequestManager.getContentList { [weak self] in
            self?.presenter.provideContentListData(result: $0)
        }
    }
}
