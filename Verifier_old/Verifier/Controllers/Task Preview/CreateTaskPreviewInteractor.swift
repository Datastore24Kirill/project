//
//  CreateTaskPreviewInteractor.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation
import UIKit

protocol CreateTaskPreviewInteractorInput: class {
    func getOrderData(orderId: Int)
    func addOrder(order: NewOrder)
    func verifyOrder(order: NewOrder, orderId: Int)
    func orderApproval(orderId: Int)
    func orderReturn(orderId: Int, reason: String)
}

protocol CreateTaskPreviewInteractorOutput: class {
    func provideOrderData(success: Bool, order: NewOrder, error: [String: Any]?)
    func provideAddOrderResponse(success: Bool, errorTitle: String, errorMessage: String)
    func provideOrderVerifierResponse(success: Bool, errorTitle: String, errorMessage: String)
    func provideOrderApprovalResponse(success: Bool, errorTitle: String, errorMessage: String)
    func provideOrderReturnResponse(success: Bool, errorTitle: String, errorMessage: String)
}

class CreateTaskPreviewInteractor: CreateTaskPreviewInteractorInput {

    //MARK: Properties
    weak var presenter: CreateTaskPreviewInteractorOutput!
    var apiRequestManager: RequestHendler!

    let decoder = JSONDecoder()
    struct RequestOrder: Codable {
        var data: Order
    }

    var order = NewOrder()
    var orderId = -1

    var newCountPhoto: Int = 0
    var newCountVideo: Int = 0

    var attackResult = (countVideos: 0, countPhotos: 0, result: ServerResponse.success((0, ""))) {
        didSet {

            switch attackResult.result {
            case .success:
                var countPhotoNeed = 0
                var countVideoNeed = 0
                order.fields.forEach {
                    if $0.type.lowercased() == "photo" {
                        countPhotoNeed += $0.photoArray.count
                    }

                    if $0.type.lowercased() == "video" {
                        countVideoNeed += 1
                    }
                }

                let equalCountVideos = newCountVideo == countVideoNeed
                let equalCountPhotos = newCountPhoto == countPhotoNeed

                if equalCountVideos && equalCountPhotos {
                    orderVerifier()
                }
            case .noInternet:
                //hideSpinner();
                print("no internet")
            case .serverError:
                //hideSpinner();
                print("not success")
            default: break
            }

        }
    }

    //MARK: Methods
    func getOrderData(orderId: Int) {

        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideOrderData(success: false, order: NewOrder(), error: ["title": "No internet connection", "message": "Check your internet connection and try again"])
            return
        }

        apiRequestManager.getOrder(id: orderId) { res, serverResult in
            if let data = res {
                if let requestOrder = try? self.decoder.decode(RequestOrder.self, from: data) {

                    let order = requestOrder.data

                    let newOrder = NewOrder()

                    newOrder.userId = order.userId
                    newOrder.isMyOrder = order.isMyOrder
                    newOrder.orderName = order.orderName!
                    newOrder.orderComment = order.orderComment
                    newOrder.address = order.verifAddr
                    newOrder.lat = order.verifAddrLatitude
                    newOrder.lng = order.verifAddrLongitude
                    newOrder.orderRate = order.orderRate
                    newOrder.orderRating = order.orderRating
                    newOrder.orderFirstName = ""
                    newOrder.orderMiddleName = ""
                    newOrder.orderLastName = ""
                    newOrder.ordetType = .inProgress

                    order.orderFields.forEach { (orderField) in

                        var data = String()

                        if let fieldData = orderField.fieldData {
                            data = fieldData
                        }

                        newOrder.fields.append(

                            Field(label: orderField.fieldName ?? "",
                                  type: orderField.fieldType ?? "",
                                  name: orderField.fieldDescription ?? "",
                                  minCount: orderField.fieldMinCount ?? "",
                                  data: data,
                                  photoArray: [],
                                  videoData: nil))
                    }
                    print("FFFF \(order.orderFields)")

                    self.presenter.provideOrderData(success: true, order: newOrder, error: nil)
                }
            }
        }
    }

    func orderVerifier() {

        var tempFields: [[String: AnyObject]] = [[String: AnyObject]]()

        order.fields.forEach { (field) in
            switch field.type.lowercased() {
            case "txt":
                let txtField: [String : String] = [
                    "fieldType" : field.type.uppercased(),
                    "fieldName" : field.label,
                    "fieldDescription" : field.name,
                    "fieldData" : field.data,
                    "fieldMinCount" : field.minCount
                ]
                tempFields.append(txtField as [String : AnyObject])
            case "photo":
               
                print("PhotoURL \(field.data)")

                let imageField: [String : String] = [
                    "fieldType" : field.type.uppercased(),
                    "fieldName" : field.label,
                    "fieldDescription" : field.name,
                    "fieldData" : field.data,
                    "fieldMinCount" : field.minCount
                ]

                tempFields.append(imageField as [String : AnyObject])
            case "video":
                let videoField: [String : String] = [
                    "fieldType" : field.type.uppercased(),
                    "fieldName" : field.label,
                    "fieldDescription" : field.name,
                    "fieldData" : field.data,
                    "fieldMinCount" : "1"
                ]
                tempFields.append(videoField as [String : AnyObject])
                
            case "check":
                let checkField: [String : String] = [
                    "fieldType" : field.type.uppercased(),
                    "fieldName" : field.label,
                    "fieldDescription" : field.name,
                    "fieldData" : field.data ,
                
                ]
                tempFields.append(checkField as [String : AnyObject])
                
            case "mark":
                let markField: [String : String] = [
                    "fieldType" : field.type.uppercased(),
                    "fieldName" : field.label,
                    "fieldDescription" : field.name,
                    "fieldData" : field.data ,
                    
                    ]
                tempFields.append(markField as [String : AnyObject])
                
            default:
                break
            }
        }

        let param = [
            "orderId": self.orderId,
            "orderComment": order.orderComment,
            "orderFields": tempFields
            ] as [String : AnyObject]
        
        print("CreateTaskPreviewInteractor Param ->> \(param)")

        RequestHendler().orderVerifier(parameters: param) {[weak self] in

            self?.newCountVideo = 0
            self?.newCountPhoto = 0
            print("inf \($0)")
            switch $0 {
            case .success:
                self?.presenter.provideOrderVerifierResponse(success: true, errorTitle: "", errorMessage: "")
            case .noInternet:

                let title = "InternetErrorTitle".localized()
                let message = "InternetErrorMessage".localized()
                self?.presenter.provideOrderVerifierResponse(success: false, errorTitle: title, errorMessage: message)

            case .serverError(let error):
                print("error \(error)")
                if error == "400" {
                    let message = "AlertOrderVerifier".localized()
                    self?.presenter.provideOrderVerifierResponse(success: false, errorTitle: "", errorMessage: message)
                }else if error == "403003" {
                    let message = "Error with Location".localized()
                    self?.presenter.provideOrderVerifierResponse(success: false, errorTitle: "", errorMessage: message)
                } else {
                    let title = "InternetErrorTitle".localized()
                    self?.presenter.provideOrderVerifierResponse(success: false, errorTitle: title, errorMessage: "")
                }
            default:
                break
            }
        }
    }

    private func uploadPhotos() {

        var photoData = String()

        for i in 0..<order.fields.count {
            switch attackResult.result {
            case .success:

                if order.fields[i].type.lowercased() != "photo" {
                    break
                }

                let photoArray = order.fields[i].photoArray
                print("PPP \(photoArray)")
                for j in 0..<photoArray.count {
                    if let image = order.fields[i].photoArray[j] {
                        RequestHendler().attachFile(with: i, image: image) { [weak self] res in

                            switch res {
                            case .success(let (index, link)):
                                photoData.append(link)
                                self?.order.fields[index].data = link
                            default: break
                            }

                            self?.newCountPhoto += 1
                            self?.attackResult.result = res
                        }
                    } else {

                        self.newCountPhoto += 1
                        self.attackResult.result = .success((0, ""))
                    }
                }
            default:
                break
               }
        }
    }

    private func uploadVideo() {

        for i in 0..<order.fields.count {
            switch attackResult.result {
            case .success:
                if let data = order.fields[i].videoData {
                    RequestHendler().attachFile(with: i, video: data) { [weak self] res in

                        switch res {
                        case .success(let (index, link)):
                            self?.order.fields[index].data.append(link)
                        default: break
                        }

                        self?.newCountVideo += 1
                        self?.attackResult.result = res
                    }
                }
            default:
                break
            }
        }
    }

    func addOrder(order: NewOrder) {
        if order.isPhisical {
            if order.orderFirstName.count > 0 {
                order.fields.append(Field(label: order.orderFirstName, type: "txt", name: order.orderFirstName, minCount: "", data: String(), photoArray: [], videoData: nil))
            }

            if order.orderLastName.count > 0 {
                order.fields.append(Field(label: order.orderLastName, type: "txt", name: order.orderLastName, minCount: "", data: String(), photoArray: [], videoData: nil))
            }

            if order.orderMiddleName.count > 0 {
                order.fields.append(Field(label: order.orderMiddleName, type: "txt", name: order.orderMiddleName, minCount: "", data: String(), photoArray: [], videoData: nil))
            }
        }

        RequestHendler().addOrder { [weak self] (result, respResult) in
            switch respResult {
            case .success:
                self?.presenter.provideAddOrderResponse(success: true, errorTitle: "", errorMessage: "")
            default:
                self?.presenter.provideAddOrderResponse(success: false, errorTitle: "InternetErrorTitle".localized(), errorMessage: "InternetErrorMessage".localized())
            }
        }
    }

    func verifyOrder(order: NewOrder, orderId: Int) {
        self.order = order
        self.orderId = orderId

        guard RequestHendler().isInternetAvailable() else {
            self.presenter.provideOrderVerifierResponse(success: false, errorTitle: "InternetErrorTitle".localized(), errorMessage: "InternetErrorMessage".localized())
            return
        }

        var needUploadPhoto = false
        var needUploadVideo = false
        
        print("ORDDD \(order.fields)")

        order.fields.forEach {
            if $0.type.lowercased() == "photo" {
                needUploadPhoto = true
            }

            if $0.type.lowercased() == "video" {
                needUploadVideo = true
            }
        }

        switch (needUploadPhoto, needUploadVideo) {
        case (true, true):
            uploadPhotos()
            uploadVideo()
        case (true, false):
            uploadPhotos()
        case (false, true):
            uploadVideo()
        default:
            orderVerifier()
        }
    }

    func orderApproval(orderId: Int) {
        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideOrderApprovalResponse(success: false, errorTitle: "InternetErrorTitle".localized(), errorMessage: "InternetErrorMessage".localized())
            return
        }

        apiRequestManager.orderApproval(orderId: Int64(orderId)) { (res, serverResult) in

            switch serverResult {
            case .success:
                self.presenter.provideOrderApprovalResponse(success: true, errorTitle: "", errorMessage: "")
            default:
                self.presenter.provideOrderApprovalResponse(success: false, errorTitle: "InternetErrorTitle".localized(), errorMessage: "InternetErrorMessage".localized())
            }
        }
    }

    func orderReturn(orderId: Int, reason: String) {
        guard apiRequestManager.isInternetAvailable() else {
            self.presenter.provideOrderApprovalResponse(success: false, errorTitle: "InternetErrorTitle".localized(), errorMessage: "InternetErrorMessage".localized())
            return
        }

        apiRequestManager.orderReturn(orderId: Int64(orderId), reason: reason, closure: { (res, serverResult) in

            switch serverResult {
            case .success:
                self.presenter.provideOrderReturnResponse(success: true, errorTitle: "", errorMessage: "")
            default:
                self.presenter.provideOrderReturnResponse(success: false, errorTitle: "InternetErrorTitle".localized(), errorMessage: "InternetErrorMessage".localized())
            }
        })
    }
}
