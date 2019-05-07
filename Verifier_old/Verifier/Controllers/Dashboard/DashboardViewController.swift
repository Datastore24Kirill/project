//
//  VerifiViewController.swift
//  Verifier
//
//  Created by iPeople on 30.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import Cosmos
import GoogleMaps
import PopupDialog

protocol DashboardViewControllerOutput: class {
    
    func fetchTasks()
    func fetchLogout()
    func presentFilter()
    func fetchCoordinate(with nameCity: String)
    
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D, isMyOrder: Bool)
    func didOpenDashboardDetailVC(with task: Task, rect: CGRect)
    func didOpenMenuSideVC()
    func didOpenLoginVC()
    
    func getVerifierUser()
    func updateUser(with password: String)
    func dashboardViewHideSpinner()
}

protocol DashboardViewControllerInput: class {
    func provideTasks(with tasks: [Task], result: ResponseResult)
    func provideCoordinate(with res: ServerResponse<Place>)
    func provideGetUserResult(with result: ResponseResult)
    func provideUserLogoutResult(with result: ResponseResult)
    func dashboardViewShowAlert(with: String, message: String)
    func dashboardViewHideSpinner()
}

class DashboardViewController: VerifierAppDefaultViewController {
    
    //userInfo
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var amountStarsLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var userVRFLabel: UILabel!
    @IBOutlet weak var userVRF2Label: UILabel!
    
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var noTasksLabel: UILabel!
    @IBOutlet weak var staticMoneyLabel: UILabel!
    
    
    //MARK: Properties
    
    var presenter: DashboardViewControllerOutput!
    var tasksList = [Task]()
    var selectedItem = -1
    var floatView = UIView()
    var floatRect = CGRect()
    var selectedCell = DashboardTableViewCell()
    var selectedIndex = IndexPath()
    var dashboardDetailVC: DashboardDetailViewController? = nil
    var backFromDetail = false
    
    var refreshControl: UIRefreshControl!
    var isLoading = false
    
    var needSetPassword = false
    private var alertPasswordTextFeild: String?
    private var alertRepeatPasswordTextFeild: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DashboardAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUser()
        setNeedsStatusBarAppearanceUpdate()
        setDesignChanges()
        prepareTableView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskTable.isUserInteractionEnabled = true
        self.presenter.getVerifierUser()
        
        if backFromDetail {
            backFromDetail = false
            backAnimation()
            
        } else {
            floatView.removeFromSuperview()
            prepareData()
        }
        
        if needSetPassword {
            showPasswordAlert()
        }
    }
    
    //MARK: Methods
    
    private func showPasswordAlert() {
        let alertController = UIAlertController(title: "PasswordErrorMessage".localized(), message: "", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "OK".localized(), style: .default) { [weak self] (_) in
            let errorAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK".localized(), style: .default) { [weak self] (_) in
               self?.showPasswordAlert()
            }
            errorAlertController.addAction(cancelAction)
            self?.alertPasswordTextFeild = alertController.textFields?[0].text
            self?.alertRepeatPasswordTextFeild = alertController.textFields?[1].text
            
            guard let master = alertController.textFields?[0].text, master != "" else {
                errorAlertController.title = "InternetErrorTitle".localized()
                errorAlertController.message = "PasswordErrorMessage".localized()
                self?.present(errorAlertController, animated: true, completion: nil)
                return
            }
            
            guard let confirm = alertController.textFields?[1].text, confirm != "" else {
                errorAlertController.title = "InternetErrorTitle".localized()
                errorAlertController.message = "ConfirmPasswordErrorMessage".localized()
                self?.present(errorAlertController, animated: true, completion: nil)
                return
            }
            
            guard master == confirm else {
                errorAlertController.title = "InternetErrorTitle".localized()
                errorAlertController.message = "ConfirmAndPasswordErrorMessage".localized()
                self?.present(errorAlertController, animated: true, completion: nil)
                return
            }
            
            self?.showSpinner()
            self?.presenter.updateUser(with: master)
        }
        
        alertController.addTextField { [weak self] (textField) in
            if let pass = self?.alertPasswordTextFeild {
                textField.text = pass
            } else {
                textField.placeholder = "Password".localized()
            }
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { [weak self] (textField) in
            if let pass = self?.alertRepeatPasswordTextFeild {
                textField.text = pass
            } else {
                textField.placeholder = "Repeat password".localized()
            }
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
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
        presenter.getVerifierUser()
        prepareData()
        
        
    }
    
    func showPopUpDialog() {
        // Prepare the popup assets
        Singleton.shared.isShowPopUpDialog = true
        let title = "Пройдите обучение"
        let message = "познакомится с работой приложения можно пройдя обучение"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Пропустить") {
            print("You canceled the car dialog.")
        }
        
        let user = UserDefaultsVerifier.getUser()
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "Пройти обучение", dismissOnTap: false) {
            
            let userEmail = user?.email ?? ""
            let userLastName = user?.lastName ?? ""
            let userFirstName = user?.firstName ?? ""
            let fullName = userFirstName + " " + userLastName
           
            let urlString =  "https://ispri.ng/WJ2NR?USER_EMAIL=\(userEmail)&USER_NAME=\(fullName)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            print(urlString)
            
            guard let url = URL(string: urlString) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func setDesignChanges() {
        self.headerView.horizontalMode = true
        self.headerView.diagonalMode = false
        self.headerView.startLocation = 0.0
        self.headerView.endLocation = 1.0
        staticMoneyLabel.text = "VRF" //NSLocalizedString("Currency", comment: "")
        noTasksLabel.text = "No tasks".localized()
        //self.headerView.setBlackGradient(view: self.headerView)
    }
    
    func prepareUser() {
        
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        if let name = user.firstName {
            userNameLabel.text = name
            if let lastName = user.lastName {
                userNameLabel.text = "\(name) \(lastName)"
            }
        }
        
        if let photo = user.photo {
            userPhotoImageView.downloadedFrom(link: photo)
        }
        
        if let monay = user.balance {
            userVRFLabel.text = String(Int(monay * 10))
            userVRF2Label.text = String(Int(monay))
        } else {
            userVRFLabel.text = "0"
            userVRF2Label.text = "0"
        }
        
        
        if let raiting = user.rating {
            amountStarsLabel.text = String(raiting)
        } else {
            amountStarsLabel.text = "0.0"
        }
    }
    
    func prepareData() {
        
        if !isLoading {
            showSpinner()
        }
        
        presenter.fetchTasks()
        guard let user = UserDefaultsVerifier.getUser() else { return }
        
        
        if let type = user.type {
  
            if type == "PRE_VERIFIER" && Singleton.shared.isShowPopUpDialog == false {
                    showPopUpDialog()
            }
        }
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
    
    //MARK: - Action
    @IBAction func didPressMenuButton(_ sender: UIButton) {
        openMenu()
        return
        //taskTable.isUserInteractionEnabled = false
        //presenter.didOpenMenuSideVC()
    }
    
    @IBAction func didPressFilterButton(_ sender: Any) {
        presenter.presentFilter()
    }
    
    
    @IBAction func didPressLogoutButton(_ sender: UIButton) {
        showSpinner()
        presenter.fetchLogout()
    }
    
    @IBAction func didEditProfileButton(_ sender: UIButton) {
        guard let controller = R.storyboard.profile.profileVC() else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: UITableView
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        tableView.isUserInteractionEnabled = false
        selectedIndex = indexPath
        selectedCell = tableView.cellForRow(at: indexPath) as! DashboardTableViewCell
        var cell1 = tableView.rectForRow(at: indexPath)
        selectedCell.myContentView.isHidden = true
        floatView = selectedCell.myContentView.copyView() as! UIView
        floatView.cornerRadius = 8
        floatView.clipsToBounds = true
        floatView.translatesAutoresizingMaskIntoConstraints = true
        floatView.isHidden = false
        
        cell1.origin.x = 16
        cell1.origin.y += 16
        cell1.size.width = cell1.size.width - 32
        cell1.size.height = cell1.size.height - 16
        
        let startFrame = tableView.convert(cell1, to: self.view)
        floatRect = startFrame
        
        self.view.addSubview(floatView)
        floatView.frame = startFrame
        
        UIView.animate(withDuration: 0.1, animations: {
            for view in self.floatView.subviews {
                if view.tag == 0 {
                    view.alpha = 0
                } else if view.tag == 4 {
                    view.cornerRadius = 4
                } else if view.tag == 3 {
                    view.cornerRadius = 8
                }
            }
        })
        
        if self.tasksList[indexPath.row].status == 1 {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.floatView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 140)
                self.floatView.cornerRadius = 0
                
                for view in self.floatView.subviews {
                    
                    if view.tag == 1 {
                        let label = view as! UILabel
                        //label.font = UIFont(name: "Helvetica", size: 22)
                        label.translatesAutoresizingMaskIntoConstraints = true
                        label.frame = CGRect(x: 10, y: 92.5, width: UIScreen.main.bounds.size.width - 20, height: 26)
                    }
                    
                    if view.tag == 2 {
                        let imageView = view as! UIImageView
                        imageView.translatesAutoresizingMaskIntoConstraints = true
                        imageView.clipsToBounds = true
                        imageView.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: -20, width: UIScreen.main.bounds.size.width / 2, height: 160)
                    }
                }
                
                self.view.layoutIfNeeded()
                
            }, completion: { (finished) in
                self.selectedCell.myContentView.isHidden = false
                self.presenter.didOpenDashboardDetailVC(with: self.tasksList[indexPath.row], rect: startFrame)
            })
            
        } else if self.tasksList[indexPath.row].status == 2 {
            
            self.selectedItem = indexPath.row
            self.presenter.fetchCoordinate(with: self.tasksList[indexPath.row].city)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116.0
    }
}

//MARK: DashboardViewControllerInput
extension DashboardViewController: DashboardViewControllerInput {
    
    func provideUserLogoutResult(with result: ResponseResult) {
        hideSpinner()
        self.presenter.didOpenLoginVC()
    }
    
    func provideGetUserResult(with result: ResponseResult) {
        switch result {
        case .success: prepareUser()
        default: break
        }
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
    
    func provideCoordinate(with res: ServerResponse<Place>) {
        
        switch res {
        case .success(let place):
            UIView.animate(withDuration: 0.5, animations: {
                
                self.floatView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 181)
                self.floatView.cornerRadius = 0
                self.floatView.clipsToBounds = true
                
                for view in self.floatView.subviews {
                    
                    if view.tag == 1 {
                        let label = view as! UILabel
                        //label.font = UIFont(name: "Helvetica", size: 19)
                        label.translatesAutoresizingMaskIntoConstraints = true
                        label.frame = CGRect(x: 20, y: 72, width: UIScreen.main.bounds.size.width - 40, height: 65)
                    }
                    
                    if view.tag == 2 {
                        let imageView = view as! UIImageView
                        imageView.translatesAutoresizingMaskIntoConstraints = true
                        //imageView.clipsToBounds = true
                        
                        let deviceHeight = UIScreen.main.bounds.height
                        var width: CGFloat = 228.0
                        switch deviceHeight {
                        case 568.0://iPhone 5, 5s, 5c, SE
                            width = 201.0
                        case 667.0://iPhone 6,6s, 7, 8
                            width = 228.0
                        case 736:////iPhone 6+,6s+, 7+, 8+
                            width = 248.0
                        case 812:////iPhone X
                            width = 228.0
                        default: break
                        }
                        
                        imageView.frame = CGRect(x: UIScreen.main.bounds.size.width - width + 41, y: 0, width: 229, height: 181)
                    }
                    
                    if view.tag == 4 {
                        view.translatesAutoresizingMaskIntoConstraints = true
                        view.frame.origin.x = UIScreen.main.bounds.size.width - 8 - view.frame.size.width
                        view.frame.origin.y = 34.5
                        view.cornerRadius = 4
                    }
                    
                    if view.tag == 3 {
                        view.cornerRadius = 0
                    }
                }
                
                self.view.layoutIfNeeded()
                
            }, completion: { (finished) in
                
                //self.floatView.removeFromSuperview()
                self.selectedCell.myContentView.isHidden = false
                self.presenter.didOpenTaskDetailVC(with: self.tasksList[self.selectedItem], coordinate: place.coordinate, isMyOrder: false)
            })
        default: break
        }
        
        hideSpinner()
    }
    
    func dashboardViewShowAlert(with: String, message: String) {
        showAlert(title: with, message: message)
    }
    
    func dashboardViewHideSpinner() {
        hideSpinner()
    }
    
}
