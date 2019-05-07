//
//  QRCodeInteractor.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import Foundation

protocol QRCodeInteractorOutput: class {
    func presentDashboardVC()
    func showIncorrectQRCodeAlert(with: String, message: String)
}

protocol QRCodeInteractorInput: class {
    func registrationWithQR(code: String)
}

class QRCodeInteractor: QRCodeInteractorInput {
    
    weak var presenter: QRCodeInteractorOutput!
    var apiRequestManager: RequestHendler!
    
    func registrationWithQR(code: String) {
        guard let range = code.range(of: "token=") else {
            self.presenter.showIncorrectQRCodeAlert(with: "InternetErrorTitle".localized(), message: "Error incorrect qr code".localized())
            return
        }
        let token = String(code[range.upperBound...])
        UserDefaultsVerifier.setToken(with: token)
        apiRequestManager.isValidate(token: token) { (result) in
            switch result {
            case .success:
                self.presenter.presentDashboardVC()
            default:
                UserDefaultsVerifier.deleteUser()
                self.presenter.showIncorrectQRCodeAlert(with: "InternetErrorTitle".localized(), message: "Error incorrect qr code".localized())
            }
        }
    }
    
}
