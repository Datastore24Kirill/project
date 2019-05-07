//
//  MapAllTaskViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 24/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit
import Mapbox


class MapAllTaskViewController: VerifierAppDefaultViewController, MGLMapViewDelegate, AllTaskViewControllerDelegate {
    
    
    //MARK: - OUTLETS
    @IBOutlet var mapAllTaskView: MapAllTaskView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var popUpViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backdropView: UIView!
    
    //MARK: - PROPERTIES
    var icon: UIImage!
    var popup: UILabel?
    var futures = [MGLPointFeature]()
   
    var modelAllTask = AllTaskModel()
    var data: [[String: Any]]?
    var dataSingleTask: [String: Any]?
    
    var myLocationLat: CLLocationDegrees?
    var myLocationLong: CLLocationDegrees?
    
    enum CustomError: Error {
        case castingError(String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapAllTaskView.localizationView()
        modelAllTask.delegate = self
        showSpinner()
        modelAllTask.setUserGeoLocation()
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backdropView.backgroundColor = UIColor.clear
        backdropView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopupView))
        backdropView.addGestureRecognizer(tapGesture)
        
        
        view.addSubview(backdropView)
        
       
    }
    
    func setupMap() {
        mapView.delegate = self
       
        guard let lat = LocationManager.share.currentLocation?.latitude,
            let lng = LocationManager.share.currentLocation?.longitude else {
                return
        }
        
        myLocationLat = lat
        myLocationLong = lng
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lng), zoomLevel: 12, animated: false)
        
        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        mapView.showsUserHeadingIndicator = true
        
       
        
        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func AllTaskList(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func filterButtonActipn(_ sender: Any) {
        
        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.taskFilterVC.rawValue
        
        if let taskFilterVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? TaskFilterViewController {
            taskFilterVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(taskFilterVC, animated: false)
            
        }
        
    }
    
    
    @IBAction func showTaskButtonAction(_ sender: Any) {
        if let withTraining = dataSingleTask?["withTraining"] as? Int, withTraining == 1 {
            let link = dataSingleTask?["trainingLink"] as? String
            showNeedTraining(link: link)
        } else if let orderID = dataSingleTask?["orderId"] as? Int,
            let orderName = dataSingleTask?["orderName"] as? String {
            
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
    
    
    //MARK: - DELEGETE
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [[String: Any]]) {
        
       self.data = data
        
        setupMap()
       
        if let allAnnotations = self.mapView.annotations {
            self.mapView.removeAnnotations(allAnnotations)
        }
        
        
    
        
        icon = UIImage.init(named: "Icon.Pin")
        print("Iconsss \(String(describing: icon))")
        
        let style = mapView.style
        
        print("Locale \(Locale.current)")
        
        style?.localizeLabels(into: Locale.current)
        
        
        
        
        futures = [MGLPointFeature]()
        print("futures \(futures)")
        
        for value in data {
            print("VALUE \(value)")
            addPoint(id: value["orderId"] as! Int, name: value["orderName"] as! String, lat: value["verifAddrLatitude"] as! Double, long: value["verifAddrLongitude"] as! Double)
        }
        
        
        let source = MGLShapeSource(identifier: "clusteredPorts", features: futures, options: [.clustered: true, .clusterRadius: icon.size.width])
        
        if let currentSource = mapView.style?.source(withIdentifier: "clusteredPorts") as? MGLShapeSource {
            let collection = MGLShapeCollectionFeature(shapes: futures)
            
            currentSource.shape = collection
        } else {
            style?.addSource(source)
        }

        
        
        
        
        // Use a template image so that we can tint it with the `iconColor` runtime styling property.
        style?.setImage(icon.withRenderingMode(.alwaysOriginal), forName: "icon")
        
        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
        let ports = MGLSymbolStyleLayer(identifier: "ports", source: source)
        ports.iconImageName = NSExpression(forConstantValue: "icon")
        ports.iconColor = NSExpression(forConstantValue: UIColor.darkGray.withAlphaComponent(0.9))
        ports.predicate = NSPredicate(format: "cluster != YES")
        
        if let currentPorts = mapView.style?.layer(withIdentifier: "ports") as? MGLSymbolStyleLayer {
            style?.removeLayer(currentPorts)
        }
            style?.addLayer(ports)
        
        
        
        
        // Color clustered features based on clustered point counts.
        let stops = [
            20: UIColor.lightGray,
            50: UIColor.orange,
            100: UIColor.red,
            200: UIColor.purple
        ]
        
        // Show clustered features as circles. The `point_count` attribute is built into clustering-enabled source features.
        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPorts", source: source)
        circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
        circlesLayer.circleOpacity = NSExpression(forConstantValue: 0.75)
        circlesLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white.withAlphaComponent(0.75))
        circlesLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circlesLayer.circleColor = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", UIColor.lightGray, stops)
        circlesLayer.predicate = NSPredicate(format: "cluster == YES")
        
        if let currentCirclesLayer = mapView.style?.layer(withIdentifier: "clusteredPorts") as? MGLCircleStyleLayer {
            style?.removeLayer(currentCirclesLayer)
        }
        
        style?.addLayer(circlesLayer)
        
        // Label cluster circles with a layer of text indicating feature count. The value for `point_count` is an integer. In order to use that value for the `MGLSymbolStyleLayer.text` property, cast it as a string.
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
        numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        
        numbersLayer.predicate = NSPredicate(format: "cluster == YES")
        
        if let currentNumbersLayer = mapView.style?.layer(withIdentifier: "clusteredPortsNumbers") as? MGLSymbolStyleLayer {
            style?.removeLayer(currentNumbersLayer)
        }
        
        
        style?.addLayer(numbersLayer)
    }
    
    
    //MARK: - MAPS

    func addPoint(id: Int, name: String, lat: Double, long: Double) {
        let feature = MGLPointFeature()
        feature.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        feature.attributes = ["id": id,"name":name]
        futures.append(feature)
    }
    

    
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
       
        
        
    }
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
       
        hidePopupView()
    }
    
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) throws {
        if sender.state == .ended {
            let point = sender.location(in: sender.view)
            let width = icon.size.width
            let rect = CGRect(x: point.x - width / 2, y: point.y - width / 2, width: width, height: width)
            
            let clusters = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["clusteredPorts"])
            let ports = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["ports"])
            
            if !clusters.isEmpty {
               
                let cluster = clusters.first!
                mapView.setCenter(cluster.coordinate, zoomLevel: (mapView.zoomLevel + 2), animated: true)
                print("cluster \(cluster.geoJSONDictionary())")
                
            } else if !ports.isEmpty {
                let port = ports.first!
            
                
                guard let portId = port.attribute(forKey: "id")! as? Int else {
                    throw CustomError.castingError("Could not cast port name to string")
                }
                setupViewWithInformation(id: portId)
                showPopupView()
                
            }
        }
    }
    
    
    
    @objc func hidePopupView() {
        popUpViewConstraint.constant = 110
        backdropView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showPopupView() {
        popUpViewConstraint.constant = 0
        backdropView.alpha = 1

        
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupViewWithInformation(id: Int){
        
        if let dataArray = data {
             dataArray.filter({$0["orderId"] as? Int == id}).forEach {
                print("ARR \($0)")
                dataSingleTask = $0
                if let orderTypeName = $0["orderTypeName"] as? String,
                    let withTraining = $0["withTraining"] as? Int,
                    let verifAddrLatitude = $0["verifAddrLatitude"] as? Double,
                    let verifAddrLongitude = $0["verifAddrLongitude"] as? Double,
                    let orderRate = $0["orderRate"] as? Double,
                    let orderName = $0["orderName"] as? String,
                    let orderLevel = $0["orderLevel"] as? Int {
                    
                    
                    if withTraining == 1 {
                        mapAllTaskView.bgView.backgroundColor = UIColor("#D1EFFC")
                        mapAllTaskView.iconEducation.alpha = 1
                    } else {
                        mapAllTaskView.bgView.backgroundColor = UIColor.white
                        mapAllTaskView.iconEducation.alpha = 0
                    }
                    mapAllTaskView.orderName.text = orderName
                    mapAllTaskView.orderType.text = orderTypeName
                    
                    //LOCATION
                    var distanceLocation: Double = 0
                    var isKm = false
                    if let _myLocationLat = myLocationLat,
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
                    
                    var distanceValue = "metr".localized()
                    if isKm {
                        distanceValue = "km".localized()
                    }
                    
                    mapAllTaskView.distance.text = String(distanceLocation) + " " + distanceValue
                    
                    //
                    
                    mapAllTaskView.orderRate.text = String(orderRate) + " ₽"
                    
                    //Дата исполнения
                    if let verifTimeTo = $0["verifTimeTo"] as? Int {
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
                            mapAllTaskView.termView.layer.borderColor = UIColor("#DBB705").cgColor
                            mapAllTaskView.termView.layer.borderWidth = 1
                            mapAllTaskView.termView.layer.cornerRadius = 5
                            mapAllTaskView.termLabel.text = "AllTask.DoToday".localized()
                            
                        } else if taskDateString == nextDateInFormat {
                            print("next day")
                            mapAllTaskView.termView.layer.borderColor = UIColor("#07B1D8").cgColor
                            mapAllTaskView.termView.layer.borderWidth = 1
                            mapAllTaskView.termView.layer.cornerRadius = 5
                            mapAllTaskView.termLabel.text = "AllTask.DoTomorow".localized()
                            
                        } else {
                            let dateFormatterDate = DateFormatter()
                            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
                            print(localTimeZoneAbbreviation)
                            dateFormatterDate.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
                            dateFormatterDate.locale = NSLocale.current
                            dateFormatterDate.dateFormat = "dd MMMM" //Specify your format that you want
                            let dateInFormatString = dateFormatterDate.string(from: taskDate)
                            mapAllTaskView.termView.layer.borderWidth = 0
                            mapAllTaskView.termView.layer.cornerRadius = 5
                            mapAllTaskView.termLabel.text = "AllTask.continueTo".localized() + dateInFormatString
                        }
                        
                    }
                    //
                    
                    
                        switch orderLevel {
                        case 0:
                            mapAllTaskView.orderLevel.image = UIImage.init(named: "Icon.Complexity")
                        case 1:
                            mapAllTaskView.orderLevel.image = UIImage.init(named: "Icon.СomplexitySimple")
                        case 2:
                            mapAllTaskView.orderLevel.image = UIImage.init(named: "Icon.СomplexityMedium")
                        case 3:
                            mapAllTaskView.orderLevel.image = UIImage.init(named: "Icon.СomplexityHard")
                        default: break
                        }
                    
                    
                    
                    
                } else {
                hidePopupView()
                }
                
            }
        
        
        }
    }
   
    
}
