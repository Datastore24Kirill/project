//
//  BaseDetailTaskViewController.swift
//  Verifier
//
//  Created by Mac on 31.10.17.
//  Copyright © 2017 Yatseyko Yuriy. All rights reserved.
// test

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import MobileCoreServices
import AVFoundation

protocol TaskPhotoCellProtocol: class {
    func deleteImageAtIndexPath(indexPath: IndexPath)
    func addNewImage()
}

protocol TaskVideoCellProtocol: class {
    func deleteVideoAtIndexPath(indexPath: IndexPath)
    func addNewVideo()
}

protocol DetailTaskProtocol {
    func caneckPickingMediaWithInfo()
    func didFinishPickingMediaWithInfo(image: UIImage)
}

class BaseDetailTaskViewController: VerifierAppDefaultViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var staticStatusLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var taskTitleView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var dataTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: ShadowView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var sendButton: GradientButton!
    
    @IBOutlet var starsButtons: [UIButton]!
    
    @IBOutlet weak var taskAddressLabel: UILabel!
    
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    
    enum ViewControllers: String {
        case popUpWindowVC = "PopUpWindowVC"
        case map = "TaskMapVC"
    }
    
    enum TakeFile {
        case photo, video
    }
    
    struct Photo {
        var fieldType = ""
        var fieldName = ""
        var fieldDescription = ""
        var fieldData = [String]()
        var fieldMinCount = ""
        var array = [UIImage]()
    }
    
    struct Video {
        var fieldType = ""
        var fieldName = ""
        var fieldDescription = ""
        var fieldMinCount = ""
        var fieldData = ""
        var photo: UIImage?
        var data: Data?
    }
    
    // MARK: Properties
    var picker = UIImagePickerController()
    var childViewController: UIViewController? = nil
    var delegate: DetailTaskProtocol? = nil
    var isPressBackButton = false
    
    var task = Task()
    
    var mapVC: TaskMapViewController?
    var coordinate = CLLocationCoordinate2D()
    var popUpWindowViewController: PopUpWindowViewController = PopUpWindowViewController()
    
    var fromGallery = false
    var parameters = [String: Any]()
    var selectedStar = 0
    var fromDashboard = false
    
    var takePhotosArray = [Photo]()
    var takeVideosArray = [Video]()
    var nameFieldPhotoActive = ""
    var nameFieldVideoActive = ""
    var takePhoto = true
    var isCollapseMapBool = true
    var countVideos = 0
    var countPhotos = 0
    
    var attackResult = ServerResponse.success((0, "")) {
        didSet {
            
            switch attackResult {
            case .success:
                var countPhotoNeed = 0
                takePhotosArray.forEach {
                    countPhotoNeed += $0.array.count
                }
                let equalCountVideos = takeVideosArray.count == countVideos
                let equalCountPhotos = countPhotoNeed == countPhotos
                
                if  equalCountVideos && equalCountPhotos {
                    orderVerifierTask()
                }
            case .noInternet:
                hideSpinner(); print("no internet")
            case .serverError:
                hideSpinner(); print("not success")
            default: break
            }
            
        }
    }
    
    var alertError = UIAlertController()
    
    // MARK: UIViewController Lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenHeight = UIScreen.main.bounds.height
        self.mapViewHeightConstraint.constant = screenHeight * 0.2
        staticStatusLabel.text = "ACTIVE".localized()
        sendButton.setTitle("SEND".localized(), for: .normal)
        if self.fromDashboard {
            self.backButton.alpha = 0
            self.titleLabel.alpha = 0
        } else {
            self.view.alpha = 0
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        self.dataTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        picker.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.prepareData()
        self.prepareTask()
        self.prepareDataTableView()
        self.createErrorAlert()
    }
    
    
    func createErrorAlert(){
        alertError = UIAlertController(title: "TaskErrorTitle".localized(), message: "TaskErrorDescription".localized(), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK".localized(), style: .default) { (alert: UIAlertAction!) -> Void in
        }
        alertError.addAction(cancelAction)
    }
    
    func showErrorAlert() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fromGallery {
            fromGallery = false
        } else {
//            DispatchQueue.main.async {
//                self.prepareMap()
//            }
        }
        
        animationView()
        
        UIApplication.shared.statusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sendButton?.violetButton = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.dataTableView.layer.removeAllAnimations()
        self.dataTableViewHeightConstraint.constant = self.dataTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.loadViewIfNeeded()
        }
    }
    
    func animationView() {
        
        if self.fromDashboard {
            UIView.animate(withDuration: 1.0) {
                self.backButton.alpha = 1
                self.titleLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.view.alpha = 1
            }, completion: nil)
        }
    }
    
    //MARK: - Methods
    func prepareData() {
        
    }
    
    func prepareParametersKey() {
        
        print("TASK \(task.fileds)")
        var fields = [[String: String]]()
        
        task.fileds.forEach { field in
            
            //Photo
            if field.type.lowercased() == "photo" {
                takePhotosArray.append(Photo(fieldType: field.type, fieldName: field.name, fieldDescription: field.label, fieldData: [String](), fieldMinCount: field.minCount, array: [UIImage]()))
                
            //Video
            } else if field.type.lowercased() == "video" {
                takeVideosArray.append(Video(fieldType: field.type, fieldName: field.name, fieldDescription: field.label, fieldMinCount: field.minCount, fieldData: "", photo: nil, data: nil))
            } else {
                let field = ["fieldType": field.type,
                             "fieldName": field.name,
                             "fieldDescription": field.label,
                             "fieldData": field.data,
                             "fieldMinCount": field.minCount] as [String : Any]
                
                fields.append(field as! [String : String])
            }
        }
        
        parameters.updateValue(fields, forKey: "fields")
    }
    
    func prepareTask() {
        taskTitleLabel.text = task.title
        taskAddressLabel.text = task.city
    }
    
    func prepareMap() {
        DispatchQueue.main.async {
            
            self.mapVC?.view.removeFromSuperview()
            self.mapVC?.removeFromParentViewController()
            
            self.mapVC = InternalHelper.StoryboardType.map.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.map.rawValue) as? TaskMapViewController
            
            self.mapVC?.coordinate = self.coordinate
            self.addChildViewController(self.mapVC!)
            self.mapVC!.view.frame = self.mapView.bounds
            self.mapView.addSubview(self.mapVC!.view)
            self.mapVC!.didMove(toParentViewController: self)
            
            self.mapVC?.didSelectMap.delegate(to: self, with: { (self, _) in
                self.collapseMap()
            })
            }
            
        }

    private func collapseMap() {
        self.isCollapseMapBool = !self.isCollapseMapBool
        let screenHeight = UIScreen.main.bounds.height
        var newHeigh: CGFloat = screenHeight * 0.2
        switch self.isCollapseMapBool {
        case true:
            newHeigh = screenHeight * 0.2
        case false:
            newHeigh = screenHeight * 0.5
        }
        
        self.mapViewHeightConstraint.constant = newHeigh
        UIView.animate(withDuration: 0.22) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func prepareDataTableView() {
        self.dataTableView.rowHeight = UITableViewAutomaticDimension;
        self.dataTableView.estimatedRowHeight = 120
        self.dataTableView.reloadData()
        
        self.dataTableView.sizeToFit()
        self.dataTableViewHeightConstraint?.constant = self.dataTableView.contentSize.height
        self.view.layoutIfNeeded()
        hideSpinner()
    }
    
    func showChoosePhotoActionSheet(fieldName: String) {
        
        nameFieldPhotoActive = fieldName
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take a Photo".localized(), style: .default, handler: { (action) -> Void in
            self.openCamera(viewController: self, type: .photo)
        })
        
//        let gallery = UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action) -> Void in
//            self.openGallary(viewController: self, type: .photo)
//        })
        
        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) -> Void in
        })
        
        
        alertController.addAction(takePhoto)
        //alertController.addAction(gallery)
        alertController.addAction(cancelButton)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func showChooseVideoActionSheet(fieldName: String) {
        
        nameFieldVideoActive = fieldName
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Record a Video".localized(), style: .default, handler: { (action) -> Void in
            self.openCamera(viewController: self, type: .video)
        })
        
//        let gallery = UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action) -> Void in
//            self.openGallary(viewController: self, type: .video)
//        })
        
        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) -> Void in
        })
        
        
        alertController.addAction(takePhoto)
        //alertController.addAction(gallery)
        alertController.addAction(cancelButton)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func openGallary(viewController: UIViewController, type: TakeFile)
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        switch type {
        case .video: picker.mediaTypes = [kUTTypeMovie as String]
        default : break
            
        }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func openCamera(viewController: UIViewController, type: TakeFile)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            switch type {
            case .photo:
                picker.mediaTypes = [kUTTypeImage as String]
                picker.cameraCaptureMode = .photo
            case .video:
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.cameraCaptureMode = .video
                picker.videoMaximumDuration = 59
            }
            self.present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Found".localized(), message: "This device has no Camera".localized(), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK".localized(), style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func textFieldResignFirstResponder(textField: UITextField) {
        
        let value = textField.text!
        let key = task.fileds[textField.tag].name
        
        if var fields = parameters["fields"] as? [[String: String]] {
            
            for i in 0..<fields.count {
                if fields[i]["fieldName"] == key {
                   fields[i]["fieldData"] = value
                }
            }
            
            parameters.updateValue(fields, forKey: "fields")
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
//    private func attachFile() {
//        RequestHendler().attachFile(imageData: (takePhotosArray.first?.array)!) { result in
//            switch result {
//            case .success:
//                self.hideSpinner()
//                self.popUpWindowViewController = InternalHelper.StoryboardType.other.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.popUpWindowVC.rawValue) as! PopUpWindowViewController
//                self.addChildViewController(self.popUpWindowViewController)
//                self.popUpWindowViewController.vrf = self.task.tokens
//                self.popUpWindowViewController.rating = self.task.rating
//                self.popUpWindowViewController.delegate = self
//                self.popUpWindowViewController.showSocialView = false
//
//                self.popUpWindowViewController.view.frame = UIScreen.main.bounds
//
//                self.view.addSubview(self.popUpWindowViewController.view)
//                self.popUpWindowViewController.didMove(toParentViewController: self)
//            default:
//                self.hideSpinner()
//            }
//        }
//    }
    
    func showVerifierPopUoView() {
        self.popUpWindowViewController = InternalHelper.StoryboardType.other.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.popUpWindowVC.rawValue) as! PopUpWindowViewController
        self.addChildViewController(self.popUpWindowViewController)
        self.popUpWindowViewController.vrf = self.task.tokens
        self.popUpWindowViewController.rating = self.task.rating
        self.popUpWindowViewController.delegate = self
        self.popUpWindowViewController.showSocialView = false
        
        self.popUpWindowViewController.view.frame = UIScreen.main.bounds
        
        self.view.addSubview(self.popUpWindowViewController.view)
        self.popUpWindowViewController.didMove(toParentViewController: self)
    }
    
//    func calculateUserRating() {
//
//        if let userDef = UserDefaultsVerifier.getUser() {
//            var user = userDef
//
////            if user.localRaiting == nil {
////                user.localRaiting = 0
////            }
//
////            if user.localMonay == nil {
////                user.localMonay = 0
////            }
//
//            //user.localRaiting = (user.localRaiting)! + task.rating
//            if let rating = user.rating {
//                user.rating = rating + task.rating
//            }
//
//            user.localMonay = (user.localMonay)! + task.tokens
//            UserDefaultsVerifier.saveUser(with: user)
//        }
//    }
    
    private func isAllFieldsFilled() -> Bool {

        var res = true
        
        takePhotosArray.forEach { takePhotoArray in
            if takePhotoArray.array.count == 0 { res = false }
        }
        
        if (takeVideosArray.filter { $0.data == nil }).count > 0 {
            res = false
        }
        
        if var fields = parameters["fields"] as? [[String: String]] {
            print("FIELDS-> \(parameters["fields"])")
            for i in 0..<fields.count {
                if fields[i]["fieldData"] == "" { return false }
            }
            
            parameters.updateValue(fields, forKey: "fields")
        }
        
        return res
    }
    
    private func uploadPhotos() {
        
        for i in 0..<takePhotosArray.count {
            switch attackResult {
            case .success:
                
                for j in 0..<takePhotosArray[i].array.count {
                    
                    RequestHendler().attachFile(with: i, image: takePhotosArray[i].array[j]) { [weak self] res in
                        
                        switch res {
                        case .success(let (index, link)):
                            self?.takePhotosArray[index].fieldData.append(link)
                        default: break
                        }
                        
                        self?.countPhotos += 1
                        self?.attackResult = res
                    }
                }
            default: break
            }
        }
    }
    
    private func uploadVideo() {
        
        for i in 0..<takeVideosArray.count {
                takeVideosArray.forEach {
                    switch attackResult {
                    case .success:
                        RequestHendler().attachFile(with: i, video: $0.data!) { [weak self] res in
                            
                            switch res {
                            case .success(let (index, link)):
                                self?.takeVideosArray[index].fieldData = link
                            default: break
                            }
                            
                            self?.countVideos += 1
                            self?.attackResult = res
                        }
                    default: break
                    }
                }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func orderVerifierTask() {
        
        var tempFields: [[String: AnyObject]] = [[String: AnyObject]]()
        
        if let fields = parameters["fields"] as? [[String : AnyObject]] {
            for field in fields {
                tempFields.append(field)
            }
        }
        
        takePhotosArray.forEach {
            
            var url = ""
            
            if $0.fieldData.count == 1 {
                url = "\($0.fieldData[0])"
            } else {
                for i in 0..<$0.fieldData.count {
                    if i == 0 {
                        url = "\($0.fieldData[i]), "
                    } else if i == $0.fieldData.count - 1 {
                        url = "\(url) \($0.fieldData[i])"
                    } else {
                        url = "\(url) \($0.fieldData[i]),"
                    }
                }
            }
            
            let imageField: [String : String] = [
                "fieldType" : $0.fieldType,
                "fieldName" : $0.fieldName,
                "fieldDescription" : $0.fieldDescription,
                "fieldData" : url,
                "fieldMinCount" : $0.fieldMinCount
                ]
            
            tempFields.append(imageField as [String : AnyObject])
        }
        
        takeVideosArray.forEach {
            let videoField: [String : String] = [
                "fieldType" : $0.fieldType,
                "fieldName" : $0.fieldName,
                "fieldDescription" : $0.fieldDescription,
                "fieldData" : $0.fieldData,
                "fieldMinCount" : $0.fieldMinCount
            ]
            tempFields.append(videoField as [String : AnyObject])
        }
        
        let param = [
            "orderId": task.id,
            "orderComment": task.text,
            "orderFields": tempFields
            ] as [String : AnyObject]
        
        RequestHendler().orderVerifier(parameters: param) {
            self.hideSpinner()
            
            switch $0 {
            case .success:
                //self.calculateUserRating()
                self.showVerifierPopUoView()
            case .noInternet:
                let title = "InternetErrorTitle".localized()
                let message = "InternetErrorMessage".localized()
                self.showAlert(title: title, message: message)
            case .serverError(let error):
                if error == "400" {
                    let message = "AlertOrderVerifier".localized()
                    self.showAlert(title: "", message: message)
                } else {
                    let title = "InternetErrorTitle".localized()
                    self.showAlert(title: title, message: "")
                }
            default: break
            }
        }
    }
    
    //MARK: Actions
    @IBAction func didPressBackButton(_ sender: UIButton) {
        
        isPressBackButton = true
        if scrollView.contentOffset.y == 0 {
            for controller in (self.navigationController?.viewControllers)! {
                if let dashboardVC = controller as? SideMenuViewController {
                    dashboardVC.backFromDetail = self.fromDashboard
                    _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                    return
                }
            }
            for controller in (self.navigationController?.viewControllers)! {
                if let dashboardVC = controller as? DashboardViewController {
                    dashboardVC.backFromDetail = self.fromDashboard
                    _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                    return
                }
            }
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }

    }
    
    @IBAction func didPressSendButton(_ sender: UIButton) {
        
        if isAllFieldsFilled() {
            
            showSpinner()
            
            guard RequestHendler().isInternetAvailable() else {
                print("No Interner Connection")
                hideSpinner(); return
            }
            
            if takePhotosArray.count == 0 && takeVideosArray.count == 0 {
                orderVerifierTask()
            } else {
                uploadPhotos()
                uploadVideo()
            }
            
        } else {
            showErrorAlert()
        }
    }
    
    @IBAction func didPressStarButton(_ sender: UIButton) {
        
        selectedStar = sender.tag
        
        for i in 0..<sender.tag {
            switch i {
            case 0: starsButtons[i].setBackgroundImage(#imageLiteral(resourceName: "ic_star1"), for: .normal)
            case 1: starsButtons[i].setBackgroundImage(#imageLiteral(resourceName: "ic_star2"), for: .normal)
            case 2: starsButtons[i].setBackgroundImage(#imageLiteral(resourceName: "ic_star3"), for: .normal)
            case 3: starsButtons[i].setBackgroundImage(#imageLiteral(resourceName: "ic_star4"), for: .normal)
            case 4: starsButtons[i].setBackgroundImage(#imageLiteral(resourceName: "ic_star5"), for: .normal)
            default: break
            }
        }
        
        for i in sender.tag..<starsButtons.count {
            starsButtons[i].setBackgroundImage(#imageLiteral(resourceName: "ic_star6"), for: .normal)
        }
    }
    
}

//MARK: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate
extension BaseDetailTaskViewController: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        fromGallery = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        fromGallery = true
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            for i in 0..<self.takePhotosArray.count {
                if self.takePhotosArray[i].fieldName == nameFieldPhotoActive {
                    self.takePhotosArray[i].array.append(image)
                }
            }
    
        }
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType.isEqual(kUTTypeMovie as String) {
                let videoPath = info[UIImagePickerControllerMediaURL] as? URL
                if let url = videoPath {
                    setVideoToField(url: url)
                }
            }
        
        self.dataTableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setVideoToField(url: URL) {
        
        let data = try? Data(contentsOf: url, options: .dataReadingMapped)
        
        for i in 0..<self.takeVideosArray.count {
            
            if self.takeVideosArray[i].fieldName == nameFieldVideoActive {
                
                let asset = AVAsset(url: url)
                guard
                    let dataImg = thumbnailForVideoAtURL(asset: asset),
                    let dataVideo = data else { break }
                
                let mb = Double(Double(dataVideo.count) / Double(1024) / Double(1024))
                let second = getSecondFromVideo(asset: asset)
                
                    switch (mb, second) {
                    case (0...50, 0...60):
                        self.takeVideosArray[i].data = dataVideo
                        self.takeVideosArray[i].photo = dataImg
                    case (50..., _):
                        self.showAlert(title: "Error".localized(), message: "The size of a video should not be bigger than 50 MB.".localized())
                    case (_, 60...):
                        self.showAlert(title: "Error".localized(), message: "A video should not last longer than 1 minute.".localized())
                    default:
                        self.showAlert(title: "Error".localized(), message: "A video should not last longer than 1 minute and be bigger than 50 MB.".localized())
                    }
                        
            }
        }
    }
    
    private func getSecondFromVideo(asset: AVAsset) -> Float64 {
        return CMTimeGetSeconds(asset.duration)
    }
    
    private func thumbnailForVideoAtURL(asset: AVAsset) -> UIImage? {
        
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    private func normalizedImage(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
}

extension BaseDetailTaskViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view is UIButton { return false }
        else { return true }
        
    }
}

//MARK: UIScrollViewDelegate
extension BaseDetailTaskViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y == 0 && isPressBackButton {
            for controller in (self.navigationController?.viewControllers)! {
                if let dashboardVC = controller as? SideMenuViewController {
                    dashboardVC.backFromDetail = self.fromDashboard
                    _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                    return
                }
            }
            for controller in (navigationController?.viewControllers)! {
                if let dashboardVC = controller as? DashboardViewController {
                    dashboardVC.backFromDetail = self.fromDashboard
                    _ = navigationController?.popToViewController(dashboardVC, animated: false)
                    return
                }
            }
        }
        
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
            self.logoImageViewBottomConstraint.constant = 117
            
            self.view.layoutIfNeeded()
            
        } else {
            if scrollView.contentOffset.y < 117 && scrollView.contentOffset.y > 0 {
                self.logoImageViewBottomConstraint.constant = -scrollView.contentOffset.y + 117
            } else {
                self.logoImageViewBottomConstraint.constant = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: UIScrollViewDelegate
extension BaseDetailTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.task.fileds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = self.task.fileds[indexPath.row]
        
        if field.type.lowercased() == "txt" {
            
            let fieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.fieldTableViewCell.rawValue, for: indexPath) as! FieldTableViewCell
            fieldTableViewCell.parentVC = self
            fieldTableViewCell.updateContentData(filed: field)
            fieldTableViewCell.dataTextField.tag = indexPath.row
            return fieldTableViewCell
            
        } else if field.type.lowercased() == "photo" {
            
            let photoTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.photoTableViewCell.rawValue, for: indexPath) as! PhotoTableViewCell
            
            photoTableViewCell.name = field.name
            photoTableViewCell.labelText = field.label
            photoTableViewCell.parentVC = self
            
            var takePhotoArray = [UIImage]()
            
            takePhotosArray.forEach { photos in
                if field.name == photos.fieldName {
                    takePhotoArray = photos.array
                }
            }
            
            photoTableViewCell.takePhotoArray = takePhotoArray
            photoTableViewCell.photoCollectionView.reloadData()
            return photoTableViewCell
        } else if field.type.lowercased() == "video" {
            let videoTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.videoTableViewCell.rawValue, for: indexPath) as! VideoTableViewCell
            
            videoTableViewCell.name = field.name
            videoTableViewCell.labelText = field.label
            videoTableViewCell.parentVC = self
            
            takeVideosArray.forEach { video in
                if field.name == video.fieldName {
                    videoTableViewCell.currentPhoto = video.photo
                }
            }
            
            return videoTableViewCell
        } else if field.type.lowercased() == "check" {
            let checkTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.checkTableViewCell.rawValue, for: indexPath) as! CheckTableViewCell
            
//            checkTableViewCell.name = field.name
//            checkTableViewCell.labelText = field.label
            checkTableViewCell.parentVC = self
            
        
            return checkTableViewCell
        }
        
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let field = self.task.fileds[indexPath.row]
        
        print("FIELDS \(field)")
        
        if field.type.lowercased() == "txt" {
            return UITableViewAutomaticDimension
        } else if field.type.lowercased() == "photo" {
            
            var takePhotoArray = [UIImage]()
            
            takePhotosArray.forEach { photos in
                if field.name == photos.fieldName {
                    takePhotoArray = photos.array
                }
            }
            
            if takePhotoArray.count == 0 {
                return (UIScreen.main.bounds.size.width - 20) * 2/3 + 75
            } else {
                return ((UIScreen.main.bounds.size.width - 20)/3 * 2/3) + 75
            }
        }  else if field.type.lowercased() == "video" {
            
            var takePhotoArray = [UIImage]()
            
            takePhotosArray.forEach { photos in
                if field.name == photos.fieldName {
                    takePhotoArray = photos.array
                }
            }
            
            if takePhotoArray.count == 0 {
                return (UIScreen.main.bounds.size.width - 20) * 2/3 + 75
            } else {
                return ((UIScreen.main.bounds.size.width - 20)/3 * 2/3) + 75
            }
        } else {
            return 0
        }
    }
}

//MARK: PopUpWindowProtocol
extension BaseDetailTaskViewController: PopUpWindowProtocol {
    
    func didPressOKButton() {
        self.popUpWindowViewController.view.removeFromSuperview()
        self.popUpWindowViewController.removeFromParentViewController()
        
        for controller in (self.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                dashboardVC.backFromDetail = false
                _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }
    }
    
    func didPressHidePopUpButton() {
        self.popUpWindowViewController.view.removeFromSuperview()
        self.popUpWindowViewController.removeFromParentViewController()
        
        for controller in (self.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                dashboardVC.backFromDetail = false
                _ = self.navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }
    }
    
    func didPressFacebookButton() {
        
    }
    
    func didPressTwitterButton() {
        
    }
}
