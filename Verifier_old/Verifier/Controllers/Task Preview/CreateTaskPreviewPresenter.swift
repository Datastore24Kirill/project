//
//  CreateTaskPreviewPresenter.swift
//  Verifier
//
//  Created by iPeople on 10.05.18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol CreateTaskPreviewPresenterOutput: class {
    func showMediaActionSheet()
    func showChooseVideoActionSheet()
    func showVerifierPopUoView()
    func popUpDidPressOKButton()
    func popUpDidPressHidePopUpButton()
    func navigateToDashboard()
    func navigateToChat(taskID: String)
}

class CreateTaskPreviewPresenter: CreateTaskPreviewControllerOutput, CreateTaskPreviewInteractorOutput {

    var router: CreateTaskPreviewPresenterOutput!
    weak var view: CreateTaskPreviewControllerInput!
    var interactor: CreateTaskPreviewInteractorInput!

    func orderReturn(orderId: Int, reason: String) {
        self.interactor.orderReturn(orderId: orderId, reason: reason)
    }

    func orderApproval(orderId: Int) {
        self.interactor.orderApproval(orderId: orderId)
    }

    func getOrderData(orderId: Int) {
        self.interactor.getOrderData(orderId: orderId)
    }

    func addOrder(order: NewOrder) {
        self.interactor.addOrder(order: order)
    }

    func verifyOrder(order: NewOrder, orderId: Int) {
        self.interactor.verifyOrder(order: order, orderId: orderId)
    }

    func provideOrderData(success: Bool, order: NewOrder, error: [String : Any]?) {
        self.view.provideOrderData(success: success, order: order, error: error)
    }

    func provideAddOrderResponse(success: Bool, errorTitle: String, errorMessage: String) {
        self.view.provideAddOrderResponse(success: success, errorTitle: errorTitle, errorMessage: errorMessage)
    }

    func provideOrderVerifierResponse(success: Bool, errorTitle: String, errorMessage: String) {
        self.view.provideOrderVerifierResponse(success: success, errorTitle: errorTitle, errorMessage: errorMessage)
    }

    func provideOrderApprovalResponse(success: Bool, errorTitle: String, errorMessage: String) {
        self.view.provideOrderApprovalResponse(success: success, errorTitle: errorTitle, errorMessage: errorMessage)
    }

    func provideOrderReturnResponse(success: Bool, errorTitle: String, errorMessage: String) {
        self.view.provideOrderReturnResponse(success: success, errorTitle: errorTitle, errorMessage: errorMessage)
    }

    func showMediaActionSheet() {
        self.router.showMediaActionSheet()
    }

    func showChooseVideoActionSheet() {
        self.router.showChooseVideoActionSheet()
    }

    func showVerifierPopUoView() {
        self.router.showVerifierPopUoView()
    }

    func popUpDidPressOKButton() {
        self.router.popUpDidPressOKButton()
    }

    func popUpDidPressHidePopUpButton() {
        self.router.popUpDidPressHidePopUpButton()
    }

    func navigateToDashboard() {
        self.router.navigateToDashboard()
    }
    
    func navigateToChat(taskID: String) {
        self.router.navigateToChat(taskID: taskID)
    }
}
