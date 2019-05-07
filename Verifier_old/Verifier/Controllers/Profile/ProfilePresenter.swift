//
//  ProfilePresenter.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

protocol ProfilePresenterOutput: class {
}

class ProfilePresenter: ProfileViewControllerOutput, ProfileInteractorOutput {
    
    var router: ProfilePresenterOutput!
    weak var view: ProfileViewControllerInput!
    var interactor: ProfileInteractorInput!
    
    func didEditProfile() {
        interactor.didEditProfile()
    }
    
    func provideResponseResult(with result: ResponseResult) {
        view.provideResponseResult(with: result)
    }
    
    func didTapVerify(verifAddr: String, long: Double, lat: Double, timeTo: Int) {
        interactor.verifierVerify(verifAddr: verifAddr, long: long, lat: lat, timeTo: timeTo)
    }
    
    func showProfileViewAlert(with: String, message: String) {
        view.hideProfileViewSpinner()
        view.showProfileViewAlert(with: with, message: message)
    }
}
