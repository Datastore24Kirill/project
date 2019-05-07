//
//  PublicProfileFTViewController.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelfieViewControllerOutput: class {
    func didOpenDashboardVC()
    func getTaskData(taskId: Int)
}

protocol SelfieViewControllerInput: class {
    func provideDataTask(success: Bool, task: Task?, error: [String: Any]?)
}

class SelfieViewController: BaseDetailTaskViewController {
    
    //MARK: Outlet
    
    //MARK: Properties
    var presenter: SelfieViewControllerOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SelfieAssembly.sharedInstance.configure(self)
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Methods
    override func prepareData() {
        showSpinner()
        self.presenter.getTaskData(taskId: self.task.id)
    }
    
    //MARK: Actions
}

//MARK: SelfieViewControllerInput
extension SelfieViewController: SelfieViewControllerInput {
    func provideDataTask(success: Bool, task: Task?, error: [String: Any]?) {
        if success {
            self.task = task!
            self.prepareDataTableView()
        } else {
            
        }
    }
}
