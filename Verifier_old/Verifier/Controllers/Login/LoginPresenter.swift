//
//  PublicProfileFTPresenter.swift
//  Taddrees
//
//  Created by Mac on 21.07.17.
//  Copyright © 2017 Volpis. All rights reserved.
//

import UIKit

protocol LoginPresenterOutput: class {
    func didOpenDashboardVC()
    func didOpenImagePickerVC()
}

class LoginPresenter: LoginViewControllerOutput, LoginInteractorOutput {
    
    var router: LoginPresenterOutput!
    weak var view: LoginViewControllerInput!
    var interactor: LoginInteractorInput!
    
    func didLoginFB() {
        interactor.didLoginFB()
    }
    
    func didLoginTwitter() {
        interactor.didLoginTwitter()
    }
    
    func didOpenDashboardVC() {
        router.didOpenDashboardVC()
    }
    
    func didOpenImagePickerVC() {
        router.didOpenImagePickerVC()
    }
    
    func didRegistration(with user: User) {
        interactor.didRegistration(with: user)
    }
    
    func provideResponseResult(with result: ResponseResult) {
        view.provideResponseResult(with: result)
    }

    func didRegistrWithTwitterFacebook() {
        self.view.didRegistrWithTwitterFacebook()
    }
}
