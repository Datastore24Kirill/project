//
//  TaskDetailViewController.swift
//  Verifier
//
//  Created by iPeople on 01.11.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import CoreLocation
import Cosmos

protocol TaskDetailViewControllerOutput: class {
    func didOpenDashboardVC()
    func getTaskData(taskId: Int)
}

protocol TaskDetailViewControllerInput: class {
    func provideDataTask(success: Bool, task: Task?, error: [String: Any]?)
}

class TaskDetailViewController: BaseDetailTaskViewController {

    //MARK: Outlet

    @IBOutlet weak var voteView: CosmosView!
    
    //MARK: Properties
    var presenter: TaskDetailViewControllerOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TaskDetailAssembly.sharedInstance.configure(self)
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADDD")
        showSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    //MARK: Methods
    override func prepareData() {
        showSpinner()
        self.presenter.getTaskData(taskId: task.id)
    }
    
    override func showErrorAlert() {
        present(alertError, animated: true, completion: nil)
    }

    //MARK: Actions
    
}

//MARK: TaskDetailViewControllerInput
extension TaskDetailViewController: TaskDetailViewControllerInput {
    func provideDataTask(success: Bool, task: Task?, error: [String: Any]?) {
        hideSpinner()
        if success {
            self.task = task!
            
            if self.task.verifAddrLatitude != 0.0 && self.task.verifAddrLongitude != 0.0 {
                coordinate = CLLocationCoordinate2D(latitude: self.task.verifAddrLatitude, longitude: self.task.verifAddrLongitude)
                DispatchQueue.main.async {
                    self.prepareMap()
                }
                
            }

            self.prepareDataTableView()
            self.prepareParametersKey()
        } else {
            print("error")
        }
    }
}
