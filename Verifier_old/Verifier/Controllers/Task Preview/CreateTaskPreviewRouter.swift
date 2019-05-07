//
//  CreateTaskPreviewRouter.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class CreateTaskPreviewRouting: CreateTaskPreviewPresenterOutput {

    weak var viewController: CreateTaskPreviewViewController!
    var popUpWindowViewController: PopUpWindowViewController = PopUpWindowViewController()

    enum TakeFile {
        case photo, video
    }

    enum ViewControllers: String {
        case popUpWindowVC = "PopUpWindowVC"
    }

    func showMediaActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePhoto = UIAlertAction(title: "Take a Photo".localized(), style: .default, handler: { (action) -> Void in
            self.openCamera(type: .photo)
        })

        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) -> Void in
        })

        alertController.addAction(takePhoto)
        alertController.addAction(cancelButton)

        self.viewController.present(alertController, animated: true, completion: nil)
    }

    func showChooseVideoActionSheet() {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePhoto = UIAlertAction(title: "Record a Video".localized(), style: .default, handler: { (action) -> Void in
            self.openCamera(type: .video)
        })

        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) -> Void in
        })


        alertController.addAction(takePhoto)
        alertController.addAction(cancelButton)

        self.viewController.present(alertController, animated: true, completion: nil)
    }

    func openCamera(type: TakeFile)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            viewController.picker.allowsEditing = false
            viewController.picker.sourceType = .camera
            switch type {
            case .photo:
                viewController.picker.mediaTypes = [kUTTypeImage as String]
                viewController.picker.cameraCaptureMode = .photo
            case .video:
                viewController.picker.mediaTypes = [kUTTypeMovie as String]
                viewController.picker.cameraCaptureMode = .video
                viewController.picker.videoMaximumDuration = 59
            }
            self.viewController.present(viewController.picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Found".localized(), message: "This device has no Camera".localized(), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK".localized(), style: .default, handler: nil)
            alert.addAction(ok)
            self.viewController.present(alert, animated: true, completion: nil)
        }
    }

    func showVerifierPopUoView() {

        self.popUpWindowViewController = InternalHelper.StoryboardType.other.getStoryboard().instantiateViewController(withIdentifier: ViewControllers.popUpWindowVC.rawValue) as! PopUpWindowViewController
        self.viewController.addChildViewController(self.popUpWindowViewController)
        self.popUpWindowViewController.vrf = 0//self.task.tokens
        self.popUpWindowViewController.rating = 0//self.task.rating
        self.popUpWindowViewController.delegate = self.viewController
        self.popUpWindowViewController.showSocialView = false

        self.popUpWindowViewController.view.frame = UIScreen.main.bounds

        self.viewController.view.addSubview(self.popUpWindowViewController.view)
        self.popUpWindowViewController.didMove(toParentViewController: self.viewController)
    }

    func popUpDidPressOKButton() {
        self.popUpWindowViewController.view.removeFromSuperview()
        self.popUpWindowViewController.removeFromParentViewController()

        for controller in (self.viewController.navigationController?.viewControllers)! {
            if let sideMenuVC = controller as? SideMenuViewController {
                sideMenuVC.backFromDetail = false
                _ = self.viewController.navigationController?.popToViewController(sideMenuVC, animated: false)
                return
            }
        }

        for controller in (self.viewController.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                dashboardVC.backFromDetail = false
                _ = self.viewController.navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }

        self.viewController.navigationController?.popViewController(animated: true)
    }

    func popUpDidPressHidePopUpButton() {
        self.popUpWindowViewController.view.removeFromSuperview()
        self.popUpWindowViewController.removeFromParentViewController()

        for controller in (self.viewController.navigationController?.viewControllers)! {
            if let dashboardVC = controller as? DashboardViewController {
                dashboardVC.backFromDetail = false
                _ = self.viewController.navigationController?.popToViewController(dashboardVC, animated: false)
                return
            }
        }

        self.viewController.navigationController?.popViewController(animated: true)
    }

    func navigateToDashboard() {
        DispatchQueue.main.async {
            guard let myNav = self.viewController.navigationController as? DashboardNavigationViewController else {
                return
            }
            guard let controller = R.storyboard.dashboard.dashboardVC() else { return }
            myNav.viewControllers = [controller]
        }
    }
    
    func navigateToChat(taskID: String) {
        guard let controller = R.storyboard.jivoSite.jivoSiteVC() else { return }
        
        controller.numberOfTask = taskID
        controller.isShowBackButton = true
        self.viewController.navigationController?.pushViewController(controller, animated: true)
    }
}
