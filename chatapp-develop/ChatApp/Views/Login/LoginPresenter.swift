//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol {
    func setEmailsState(result: ValidationResult)
    func setPasswordsState(result: ValidationResult)
    func successfullogin()
}

extension LoginPresenterProtocol {
    func successfullogin() {}
}

class LoginPresenter: LoginPresenterProtocol {
    private let router: LoginRouterProtocol
    private let validationDelegate: ValidationDelegateWrapper<LoginViewController.ValidationSubject>
    
    init(router: LoginRouter, validationDelegate: ValidationDelegateWrapper<LoginViewController.ValidationSubject>) {
        self.router = router
        self.validationDelegate = validationDelegate
    }
    
    func successfullogin() {
        router.showChatList()
    }
    
    func setEmailsState(result: ValidationResult) {
        validationDelegate.setState([.email: result])
    }
    
    func setPasswordsState(result: ValidationResult) {
        validationDelegate.setState([.password: result])
    }
}
