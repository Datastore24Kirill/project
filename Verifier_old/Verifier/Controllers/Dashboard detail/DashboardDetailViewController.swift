//
//  DashboardDetailViewController.swift
//  Verifier
//
//  Created by iPeople on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps

protocol DashboardDetailViewControllerOutput: class {
    func didOpenTaskDetailVC(with task: Task, coordinate: CLLocationCoordinate2D)
    func fetchChangeTask(with id: Int, param: [String : Any])
//    func fetchCoordinate(with nameCity: String)
}

protocol DashboardDetailViewControllerInput: class {
    func provideResultChangeTask2(with result: ResponseResult)
//    func provideCoordinate(with coordinate: CLLocationCoordinate2D?, result: ResponseResult)
    func provideError()
}

class DashboardDetailViewController: VerifierAppDefaultViewController {
    
    @IBOutlet weak var hideDoneContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var showDoneContainerViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hideActiveViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var showActiveViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var mainScrollViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var scrollBodyView: UIView!
    @IBOutlet weak var logoImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var startButton: GradientButton!
    
    @IBOutlet weak var vrfLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var detailsStaticLabel: UILabel!
    
    @IBOutlet weak var startButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerActiveLabelsView: UIView!
    
    //done
    @IBOutlet weak var doneLabel: UIButton!
    @IBOutlet weak var containerDoneLabelsView: UIView!
    @IBOutlet weak var staticYouveGotLabel: UILabel!
    @IBOutlet weak var doneVRFLabel: UILabel!
    @IBOutlet weak var doneVoteLabel: UILabel!
    @IBOutlet weak var staticHashLabel: UILabel!
    @IBOutlet weak var doneHashLabel: UILabel!
    
    @IBOutlet weak var staticCurrencyTextLabel: UILabel!

    var presenter: DashboardDetailViewControllerOutput!
    var task = Task()
    var floatView = UIView()
    var floatViewRect = CGRect()
    var setWhiteStatusBar = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DashboardDetailAssembly.sharedInstance.configure(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if setWhiteStatusBar {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewDidLayoutSubviews() {
        startButton?.violetButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        startButton.setTitle("START".localized(), for: .normal)
        detailsStaticLabel.text = "\("Details".localized()):"
        doneLabel.setTitle("DONE".localized(), for: .normal)
        self.headerView.isHidden = false
                
        backButton.alpha = 0
        headerTitleLabel.alpha = 0
        scrollBodyView.alpha = 0
        
        self.logoImageViewBottomConstraint.constant = 70
        prepareTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDesignChanges()
        
        UIView.animate(withDuration: 0.4) {
            self.backButton.alpha = 1
            self.headerTitleLabel.alpha = 1
            self.scrollBodyView.alpha = 1
        }
        
        //UIApplication.shared.statusBarStyle = .lightContent
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //UIApplication.shared.statusBarStyle = .default
    }
    
    func setDesignChanges() {
        
        if task.status == 3 || task.status == 4 {
            startButtonHeightConstraint?.constant = 4.0
            startButton?.isHidden = true
        }

    }
    
    func prepareTask() {
        doneVRFLabel.isHidden = true
        print("TaskStatus \(task.status)")
        switch task.status {
        case 3,4:
            
            self.hideDoneContainerViewConstraint.priority = UILayoutPriority(rawValue: 333)
            self.showDoneContainerViewConstraint.priority = UILayoutPriority(rawValue: 999)
            
            self.hideActiveViewConstraint.priority = UILayoutPriority(rawValue: 999)
            self.showActiveViewConstraint.priority = UILayoutPriority(rawValue: 333)
            
            doneLabel.isHidden = true
            doneVRFLabel.text = "\(task.tokens) \("Currency".localized())"
            doneVRFLabel.isHidden = true
            
        default:
            self.hideDoneContainerViewConstraint.priority = UILayoutPriority(rawValue: 999)
            self.showDoneContainerViewConstraint.priority = UILayoutPriority(rawValue: 333)
            
            self.hideActiveViewConstraint.priority = UILayoutPriority(rawValue: 333)
            self.showActiveViewConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        
        
        locationLabel.text = task.city
        descriptionTextView.text = task.text
        taskTitleLabel.text = task.title
        print("TOKEN $ \(task)")
        if task.tokens > 0 {
            vrfLabel.alpha = 1
            vrfLabel.text = "\(task.tokens) руб."
        } else {
            vrfLabel.alpha = 0
        }
        
    }
    
    //MARK: Action
    @IBAction func didPressBackButton(_ sender: UIButton) {
        
        for controller in (navigationController?.viewControllers)! {
            if let sideMenuVC = controller as? SideMenuViewController {
                sideMenuVC.backFromDetail = true
                _ = navigationController?.popToViewController(sideMenuVC, animated: false)
                return
            }
        }
        
        for controller in (navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                dashboardVC.backFromDetail = true
                _ = navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }
    }
    
    @IBAction func didPressStartButton(_ sender: GradientButton) {
        
        showSpinner()
        guard RequestHendler().isInternetAvailable() else {
           hideSpinner()
            return
        }

        RequestHendler().orderAccept(id: self.task.id) {[weak self] (result) in

            self?.hideSpinner()
            if result {
                UIApplication.shared.statusBarStyle = .lightContent
                self?.setWhiteStatusBar = true
                self?.setNeedsStatusBarAppearanceUpdate()
                
                let coordinate = CLLocationCoordinate2D(latitude: 55.740557, longitude: 37.610006)
                self?.presenter.didOpenTaskDetailVC(with: (self?.task)!, coordinate: coordinate)
            }
        }
    }
}

//MARK: UIScrollView
extension DashboardDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
            self.logoImageViewBottomConstraint.constant = 70

            self.view.layoutIfNeeded()
            
        } else {
            if scrollView.contentOffset.y < 70 && scrollView.contentOffset.y > 0 {
                self.logoImageViewBottomConstraint.constant = -scrollView.contentOffset.y + 70
                self.logoImageView.layoutIfNeeded()
            } else {
             
                self.logoImageViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

//MARK: DashboardViewControllerInput
extension DashboardDetailViewController: DashboardDetailViewControllerInput {
    
    func provideResultChangeTask2(with result: ResponseResult) {

//        self.hideSpinner()
//
//        switch result {
//        case .success:
//            UIApplication.shared.statusBarStyle = .lightContent
//            setWhiteStatusBar = true
//            setNeedsStatusBarAppearanceUpdate()
//
//            var coordinate = CLLocationCoordinate2D()
//
//            if task.verifAddrLatitude == 0.0 && task.verifAddrLongitude == 0.0 {
//                coordinate = CLLocationCoordinate2D(latitude: 55.740557, longitude: 37.610006)
//            } else {
//                coordinate = CLLocationCoordinate2D(latitude: task.verifAddrLatitude, longitude: task.verifAddrLongitude)
//            }
//
//            presenter.didOpenTaskDetailVC(with: task, coordinate: coordinate)
//            //presenter.fetchCoordinate(with: task.city)
//        default: break
//            //startButton?.isUserInteractionEnabled = true
//        }

    }
    
    func provideError() {
        UIApplication.shared.statusBarStyle = .lightContent
        setWhiteStatusBar = true
        setNeedsStatusBarAppearanceUpdate()
        self.presenter.didOpenTaskDetailVC(with: task, coordinate: CLLocationCoordinate2D(latitude: 55.7522200, longitude: 37.6155600))
        
        hideSpinner()
    }
    
//    func provideCoordinate(with coordinate: CLLocationCoordinate2D?, result: ResponseResult) {
//        self.hideSpinner()
//        switch result {
//        case .success:
//            if let newCoordinate = coordinate {
//                UIApplication.shared.statusBarStyle = .lightContent
//                setWhiteStatusBar = true
//                setNeedsStatusBarAppearanceUpdate()
//
//                presenter.didOpenTaskDetailVC(with: task, coordinate: newCoordinate)
//            }
//        default: break
//            //startButton?.isUserInteractionEnabled = true
//        }
//        hideSpinner()
//    }
}
