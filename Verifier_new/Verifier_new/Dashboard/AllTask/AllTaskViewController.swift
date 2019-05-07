//
//  AllTaskViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import SwiftPullToRefresh
import CoreLocation

class AllTaskViewController: VerifierAppDefaultViewController, EmptyDataSetSource, EmptyDataSetDelegate, AllTaskViewControllerDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var allTaskView: AllTaskView!
    
    //MARK: - PROPERTIES
    var model = AllTaskModel()
    var task: [[String: Any]]?
    var myLocationLat: CLLocationDegrees?
    var myLocationLong: CLLocationDegrees?
    let resultRealm = RealmSwiftAction.listRealm()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locolizeTabBar()
        
        allTaskView.localizationView()
        showSpinner()
        model.setUserGeoLocation()
        relodGeoLocation()
        tableView.backgroundColor = UIColor.clear
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.estimatedRowHeight = 93.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        
        model.delegate = self
        
        if let pushToken = resultRealm.first?.pushToken {
            print("TokenPUSHNOW \(pushToken)")
            sendPushToken(pushToken: pushToken)
        }
        
        
        
        setupEmptyTable()
        setupPullToReloadTable()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //SETUP
    
    func relodGeoLocation() {
        guard let lat = LocationManager.share.currentLocation?.latitude,
            let lng = LocationManager.share.currentLocation?.longitude else {
                showAlertError(with: "Error".localized(), message: "Error.GeoLocation".localized())
                return
        }
        myLocationLat = lat
        myLocationLong = lng
    }
    
    func setupPullToReloadTable() {
        guard
            let url = Bundle.main.url(forResource: "logo_pre", withExtension: "gif"),
            let data = try? Data(contentsOf: url) else { return }
        print("DATA \(data)")
        tableView.spr_setGIFHeader(data: data, isBig: false, height: 150) {
            self.relodGeoLocation()
            self.model.setUserGeoLocation()
        }
    }
    
    func setupEmptyTable() {
        // create attributed string
        let emptyTitle = "Notasks".localized()
        let emptyAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#333333") ]
        let emptyAttrString = NSAttributedString(string: emptyTitle, attributes: emptyAttribute)
        
        let emptyDescTitle = "Notasks.AllTask".localized()
        let emptyDescAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#333333") ]
        let emptyDescAttrString = NSAttributedString(string: emptyDescTitle, attributes: emptyDescAttribute)
        
        let buttonTitle = "Refresh".localized()
        let buttonAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#FFFFFF") ]
        let buttonAttrString = NSAttributedString(string: buttonTitle, attributes: buttonAttribute)
        
       
        
        
        tableView.emptyDataSetView { view in
            view.titleLabelString(emptyAttrString)
                .detailLabelString(emptyDescAttrString)
                .image(UIImage.init(named: "Logotype_small"))
                .shouldFadeIn(true)
                .buttonTitle(buttonAttrString, for: .normal)
                .buttonBackgroundImage(UIImage.init(named: "Refresh.Button"), for: .normal)
                .shouldFadeIn(true)
                .isScrollAllowed(true)
                .isTouchAllowed(true)
                .didTapDataButton {
                    print("reload")
                    self.showSpinner()
                    self.relodGeoLocation()
                    self.model.setUserGeoLocation()
                    
            }
        }
    }
    
    
    //MARK: - ACTIONS
    @IBAction func filterButtonAction(_ sender: Any) {
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.taskFilterVC.rawValue
        
        if let taskFilterVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskFilterViewController {
            taskFilterVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(taskFilterVC, animated: false)
            
        }
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.mapAllTaskVC.rawValue
        
        if let mapAllTaskVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? MapAllTaskViewController {
            
            self.navigationController?.pushViewController(mapAllTaskVC, animated: false)
            
        }
        
        
    }
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [[String: Any]]) {
        task = data
        tableView.spr_endRefreshing()
        tableView.reloadData()
    }
    
}

//MARK: UITableView
extension AllTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return task?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let data = task?[indexPath.section]
        print("DATA TASK \(String(describing: data))")
        //LOCATION
        var distanceLocation: Double = 0
        var isKm = false
        if let verifAddrLatitude = data?["verifAddrLatitude"] as? Double,
            let verifAddrLongitude = data?["verifAddrLongitude"] as? Double,
            let _myLocationLat = myLocationLat,
            let _myLocationLong = myLocationLong {
            
            let myCoordinate = CLLocation(latitude: _myLocationLat, longitude: _myLocationLong)
            let taskCoordinate = CLLocation(latitude: verifAddrLatitude, longitude: verifAddrLongitude)
            let distanceInMeters = myCoordinate.distance(from: taskCoordinate) // result is in meters
            print("DISTANCE \(distanceInMeters)")
            if  distanceInMeters < 1000 {
                distanceLocation = distanceInMeters.rounded(toPlaces: 2)
            } else {
                isKm = true
                distanceLocation = (distanceInMeters/1000).rounded(toPlaces: 2)
            }
            
            
        }
       
        
        if let withTraining = data?["withTraining"] as? Int, withTraining == 1 {
            let dashboardCellWithEducation = tableView.dequeueReusableCell(withIdentifier: "CellWithEducation", for: indexPath) as! AllTaskWithEducationCell
            
            dashboardCellWithEducation.typeTaskLabel.text = data?["orderTypeName"] as? String
            dashboardCellWithEducation.titleTaskLabel.text = data?["orderName"] as? String
            var distanceValue = "metr".localized()
            if isKm {
                distanceValue = "km".localized()
            }
            
            dashboardCellWithEducation.distanceTaskLabel.text = String(distanceLocation) + " " + distanceValue
            
            let orderPrice = data?["orderRate"] as? Double ?? 0
            dashboardCellWithEducation.priceLabel.text = String(orderPrice) + " ₽"
            
            //Дата исполнения
            if let verifTimeTo = data?["verifTimeTo"] as? Int {
                print("verifTimeTo \(verifTimeTo)")
                let taskDate = Date(timeIntervalSince1970: Double(verifTimeTo))
                let dateFormatter = DateFormatter()
                var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
                print(localTimeZoneAbbreviation)
                dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "dd.MM.YYYY" //Specify your format that you want
                let taskDateString = dateFormatter.string(from: taskDate)
                print("DATE TASK: \(taskDateString)")
                
                //Текущая дата
                let currentDate = Date()
                let currentDateInFormat = dateFormatter.string(from: currentDate)
                print("DATE NOW: \(currentDateInFormat)")
                
                //завтра
                let calendar = Calendar.current
                let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate)
                let nextDateInFormat = dateFormatter.string(from: nextDate!)
                print("DATE NEXT: \(nextDateInFormat)")
                
                //Сегодня цвет: DBB705
                //Завтра цвет: 07B1D8
                
                
                
                if  taskDateString == currentDateInFormat {
                    print("date now")
                    dashboardCellWithEducation.termView.layer.borderColor = UIColor("#DBB705").cgColor
                    dashboardCellWithEducation.termView.layer.borderWidth = 1
                    dashboardCellWithEducation.termTaskLabel.text = "AllTask.DoToday".localized()
                    
                } else if taskDateString == nextDateInFormat {
                    print("next day")
                    dashboardCellWithEducation.termView.layer.borderColor = UIColor("#07B1D8").cgColor
                    dashboardCellWithEducation.termView.layer.borderWidth = 1
                    dashboardCellWithEducation.termTaskLabel.text = "AllTask.DoTomorow".localized()
                    
                } else {
                    let dateFormatterDate = DateFormatter()
                    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
                    print(localTimeZoneAbbreviation)
                    dateFormatterDate.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
                    dateFormatterDate.locale = NSLocale.current
                    dateFormatterDate.dateFormat = "dd MMMM" //Specify your format that you want
                    let dateInFormatString = dateFormatterDate.string(from: taskDate)
                    dashboardCellWithEducation.termView.layer.borderWidth = 0
                    dashboardCellWithEducation.termTaskLabel.text = "AllTask.continueTo".localized() + dateInFormatString
                }
                
            }
            //
            
            if let orderLevel = data?["orderLevel"] as? Int {
                switch orderLevel {
                case 0:
                    dashboardCellWithEducation.orderLevel.image = UIImage.init(named: "Icon.Complexity")
                case 1:
                    dashboardCellWithEducation.orderLevel.image = UIImage.init(named: "Icon.СomplexitySimple")
                case 2:
                    dashboardCellWithEducation.orderLevel.image = UIImage.init(named: "Icon.СomplexityMedium")
                case 3: 
                    dashboardCellWithEducation.orderLevel.image = UIImage.init(named: "Icon.СomplexityHard")
                default: break
                }
            }
            
            
            
            return dashboardCellWithEducation
        } else {
            let dashboardCellWithoutEducation = tableView.dequeueReusableCell(withIdentifier: "CellWithoutEducation", for: indexPath) as! AllTaskWithoutEducationCell
            
            
            
            
            dashboardCellWithoutEducation.typeTaskLabel.text = data?["orderTypeName"] as? String
            dashboardCellWithoutEducation.titleTaskLabel.text = data?["orderName"] as? String
            var distanceValue = "metr".localized()
            if isKm {
                distanceValue = "km".localized()
            }
            
            dashboardCellWithoutEducation.distanceTaskLabel.text = String(distanceLocation) + " " + distanceValue
            
            let orderPrice = data?["orderRate"] as? Double ?? 0
            dashboardCellWithoutEducation.priceLabel.text = String(orderPrice) + " ₽"
            
            //Дата исполнения
            if let verifTimeTo = data?["verifTimeTo"] as? Int {
                let taskDate = Date(timeIntervalSince1970: Double(verifTimeTo))
                let dateFormatter = DateFormatter()
                var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
                print(localTimeZoneAbbreviation)
                dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "dd.MM.YYYY" //Specify your format that you want
                let taskDateString = dateFormatter.string(from: taskDate)
                print("DATE TASK: \(taskDateString)")
                
                //Текущая дата
                let currentDate = Date()
                let currentDateInFormat = dateFormatter.string(from: currentDate)
                print("DATE NOW: \(currentDateInFormat)")
                
                //завтра
                let calendar = Calendar.current
                let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate)
                let nextDateInFormat = dateFormatter.string(from: nextDate!)
                print("DATE NEXT: \(nextDateInFormat)")
                
                //Сегодня цвет: DBB705
                //Завтра цвет: 07B1D8
                
                
                
                if  taskDateString == currentDateInFormat {
                    print("date now")
                    dashboardCellWithoutEducation.termView.layer.borderColor = UIColor("#DBB705").cgColor
                    dashboardCellWithoutEducation.termView.layer.borderWidth = 1
                    dashboardCellWithoutEducation.termTaskLabel.text = "AllTask.DoToday".localized()
                    
                } else if taskDateString == nextDateInFormat {
                    print("next day")
                    dashboardCellWithoutEducation.termView.layer.borderColor = UIColor("#07B1D8").cgColor
                    dashboardCellWithoutEducation.termView.layer.borderWidth = 1
                    dashboardCellWithoutEducation.termTaskLabel.text = "AllTask.DoTomorow".localized()
                    
                } else {
                    let dateFormatterDate = DateFormatter()
                    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
                    print(localTimeZoneAbbreviation)
                    dateFormatterDate.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
                    dateFormatterDate.locale = Locale(identifier: InternalHelper.sharedInstance.getCurrentLanguage())

                    dateFormatterDate.dateFormat = "dd MMMM" //Specify your format that you want
                    let dateInFormatString = dateFormatterDate.string(from: taskDate)
                    dashboardCellWithoutEducation.termView.layer.borderWidth = 0
                    dashboardCellWithoutEducation.termTaskLabel.text = "AllTask.continueTo".localized() + dateInFormatString
                }
                
            }
            //
            
            if let orderLevel = data?["orderLevel"] as? Int {
                switch orderLevel {
                case 0:
                    dashboardCellWithoutEducation.orderLevel.image = UIImage.init(named: "Icon.Complexity")
                case 1:
                    dashboardCellWithoutEducation.orderLevel.image = UIImage.init(named: "Icon.СomplexitySimple")
                case 2:
                    dashboardCellWithoutEducation.orderLevel.image = UIImage.init(named: "Icon.СomplexityMedium")
                case 3:
                    dashboardCellWithoutEducation.orderLevel.image = UIImage.init(named: "Icon.СomplexityHard")
                default: break
                }
            }
            
            return dashboardCellWithoutEducation
        }
        
        
        
        // add border and color
        
//        dashboardCell.layer.borderColor = UIColor("#EFEFEF").cgColor
//        dashboardCell.layer.borderWidth = CGFloat(0.72)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let data = task?[indexPath.section]
        
        if let withTraining = data?["withTraining"] as? Int, withTraining == 1 {
            let link = data?["trainingLink"] as? String
            showNeedTraining(link: link)
        } else if let orderID = data?["orderId"] as? Int,
            let orderName = data?["orderName"] as? String{
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.taskInfoVC.rawValue
            
            if let taskInfoVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskInfoViewController {
                taskInfoVC.orderId = String(orderID)
                taskInfoVC.orderName = orderName
                taskInfoVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(taskInfoVC, animated: true)
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93.0
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(7)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
}
