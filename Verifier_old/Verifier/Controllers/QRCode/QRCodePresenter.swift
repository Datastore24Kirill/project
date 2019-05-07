//
//  QRCodePresenter.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol QRCodePresenterOutput {
    func presentPreviousVC()
    func presentDashboardVC()
}

class QRCodePresenter {

    var router: QRCodePresenterOutput!
    weak var view: QRCodeViewControllerInput!
    var interactor: QRCodeInteractorInput!
}

extension QRCodePresenter: QRCodeViewControllerOutput {
    
    func presentPreviousVC() {
        router.presentPreviousVC()
    }
    
    func registrationWithQR(code: String) {
        interactor.registrationWithQR(code: code)
    }
}

extension QRCodePresenter: QRCodeInteractorOutput {
    func presentDashboardVC() {
        qrCodeViewHideSpinner()
        router.presentDashboardVC()
    }
    
    func showIncorrectQRCodeAlert(with: String, message: String) {
        qrCodeViewHideSpinner()
        view.showAlertError(with: with, message: message)
    }
    
    func qrCodeViewHideSpinner() {
        view.qrCodeViewHideSpinner()
    }
}
