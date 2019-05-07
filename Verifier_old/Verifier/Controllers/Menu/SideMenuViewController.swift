//
//  PublicProfileFTViewController.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit
import CoreLocation

protocol SideMenuViewControllerOutput: class {
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect, navTitle: String)
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D)
    
    func fetchCoordinate(with nameCity: String)
    func fetchTasks(orderType: OrderTypeRequest)
}

protocol SideMenuViewControllerInput: class {
    func provideCoordinate(with res: ServerResponse<Place>)
    func provideTasks(with tasks: [Task], result: ResponseResult)
}

class SideMenuViewController: VerifierAppDefaultViewController {
    
    //MARK: Outlet
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var noTasksView: UIView!
    @IBOutlet weak var noTasksLabel: UILabel!
    @IBOutlet weak var staticTextTasksLabel: UILabel!
    
    //MARK: Properties
    var presenter: SideMenuViewControllerOutput!
    var tasksList = [Task]()
    var selectedCell = DashboardTableViewCell()
    var floatView = UIView()
    var floatRect = CGRect()
    var backFromDetail = false
    var selectedIndex = IndexPath()
    var selectedItem = -1
    var orderType: OrderTypeRequest = .myOrder
    
    var refreshControl: UIRefreshControl!
    var isLoading = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SideMenuAssembly.sharedInstance.configure(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.setBlackGradient(view: headerView)
        noTasksLabel.text = "No tasks done".localized()
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        staticTextTasksLabel.text = "Tasks".localized()
        setNeedsStatusBarAppearanceUpdate()
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        taskTable.isUserInteractionEnabled = true
        if backFromDetail {
            backFromDetail = false
            //backAnimation()
        } else {
            floatView.removeFromSuperview()
            prepareTask()
        }
    }
    
    //Methods
    
    func prepareTableView() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            taskTable.refreshControl = refreshControl
        } else {
            taskTable.addSubview(refreshControl)
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        isLoading = true
        prepareTask()
    }
    
    func prepareTask() {
        
        if !isLoading {
            showSpinner()
        }

        presenter.fetchTasks(orderType: orderType)
    }
    
    
    func backAnimation() {
        
        self.floatView.isHidden = false
        let cell = taskTable.cellForRow(at: selectedIndex) as! DashboardTableViewCell
        cell.myContentView.alpha = 0
        cell.markerImageView.alpha = 0
        cell.locationLabel.alpha = 0
        cell.vrfLabel.alpha = 0
        cell.distanceLabel.alpha = 0
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.floatView.frame = self.floatRect
                self.floatView.cornerRadius = 8
                
                for view in self.floatView.subviews {
                    
                    if view.tag == 1 {
                        let label = view as! UILabel
                        label.translatesAutoresizingMaskIntoConstraints = true
                        label.frame = CGRect(x: 12, y: 12, width: UIScreen.main.bounds.size.width - 56, height: 23)
                    }
                    
                    if view.tag == 2 {
                        let imageView = view as! UIImageView
                        imageView.translatesAutoresizingMaskIntoConstraints = true
                        imageView.frame = CGRect(x: self.floatRect.size.width - 110, y: 0, width: 110, height: self.floatRect.size.height)
                    }
                    
                    if view.tag == 4 {
                        let activeView = view
                        activeView.translatesAutoresizingMaskIntoConstraints = true
                        activeView.frame = CGRect(x: self.floatRect.size.width - 8 - activeView.frame.size.width, y: 14.5, width: activeView.frame.size.width, height: activeView.frame.size.height)
                    }
                }
                
                self.view.layoutIfNeeded()
                
            }, completion: { (finished) in
                self.floatView.isHidden = true
                cell.myContentView.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    cell.markerImageView.alpha = 1
                    cell.locationLabel.alpha = 1
//                    cell.vrfLabel.alpha = 1
//                    cell.distanceLabel.alpha = 1
                })
            })
        }
    }
    
    //MARK: Action
    @IBAction func didPressMenuButton(_ sender: UIButton) {
        openMenu()
    }
}

//MARK: SideMenuViewControllerInput
extension SideMenuViewController: SideMenuViewControllerInput {
    
    func provideCoordinate(with res: ServerResponse<Place>) {
        switch res {
        case .success(let place):
            self.presenter.didOpenTaskDetailVC(with: self.tasksList[self.selectedItem], coordinate: place.coordinate )
        default: break
        }
        
        hideSpinner()
    }
    
    func provideTasks(with tasks: [Task], result: ResponseResult) {
        
        if self.refreshControl != nil {
            self.refreshControl.endRefreshing()
        }
        
        isLoading = false
        
        switch result {
        case .success, .failed:
            tasksList = tasks
            fallthrough
        default:
            if tasksList.count == 0 {
                noTasksLabel.isHidden = false
            } else {
                noTasksLabel.isHidden = true
                
            }
            
            DispatchQueue.main.async {
                self.taskTable.reloadData()
                self.hideSpinner()
            }
        }
        
    }
}

//MARK: UITableView
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dashboardCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.dashboardCell.rawValue, for: indexPath) as! DashboardTableViewCell
        dashboardCell.taskStatus = tasksList[indexPath.row].status
        dashboardCell.updateContentData(with: tasksList[indexPath.row])
        return dashboardCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var navTitle = ""
        switch orderType {
        case .myOrder:
            navTitle = "My Orders".localized();
        case .verifyOrder:
            navTitle = "In work".localized();
        }

        let currentTask = self.tasksList[indexPath.row]

        if currentTask.status == 4 || currentTask.status == 3 || currentTask.status == 1 {
            self.presenter.didOpenDashboardDetailVC(with: self.tasksList[indexPath.row], rect: .zero, navTitle: navTitle)
            
        } else if currentTask.status == 2 || currentTask.status == 5  {
            self.selectedItem = indexPath.row
            self.presenter.fetchCoordinate(with: self.tasksList[indexPath.row].city)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

