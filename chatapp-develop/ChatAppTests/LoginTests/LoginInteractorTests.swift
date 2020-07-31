//
//  LoginInteractorTests.swift
//  ChatAppTests
//
//  Created by Stanislav Marynych on 7/28/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import XCTest
@testable import ChatApp

class LoginPresenterMock: LoginPresenterProtocol {
    var callback: ((Bool, ValidationResult) -> Void)?
    
    private var emailWasValidated = false {
        didSet {
            callback?(emailWasValidated, emailValidationResult)
        }
    }
    private var passwordWasValidated = false {
        didSet {
            callback?(passwordWasValidated, passwordValidationResult)
        }
    }
    
    private var emailValidationResult = ValidationResult(false, "")
    private var passwordValidationResult = ValidationResult(false, "")
    
    func setEmailsState(result: ValidationResult) {
        emailValidationResult = result
        emailWasValidated = true
    }
    
    func setPasswordsState(result: ValidationResult) {
        passwordValidationResult = result
        passwordWasValidated = true
    }
}

struct ConfugurationDataProviderMock: ConfigurationDataProviderProtocol {
    func getConfig(completion: ([String : String]) -> Void) {
        completion([
            ConfigurationKeys.validationRuleEmail: "^[a-zA-Z0-9.!#$%&*+/=?^_`{}~-]+@([a-zA-Z0-9-]+)[.]([a-zA-Z0-9.-]{2,})$",
            ConfigurationKeys.validationRulePassword: "^[A-Za-z0-9#&%]{9,128}$"
        ])
    }
}

class LoginInteractorTests: XCTestCase {
    private var interactor: LoginInteractorProtocol?
    private var presenter: LoginPresenterMock?
    
    override func setUpWithError() throws {
        presenter = LoginPresenterMock()
        
        guard let presenter = presenter else { return }
        
        interactor = LoginInteractor(presenter: presenter, configurationDataProvider: ConfugurationDataProviderMock())
        interactor?.setup()
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
        
        try super.tearDownWithError()
    }

    func testEmailSetting() {
        let email = "some email"
        interactor?.setEmail(value: email)
        
        presenter?.callback = { emailWasValidated, _ in
            XCTAssertTrue(emailWasValidated)
        }
        
    }
    
    func testPasswordSetting() {
        let password = "some password"
        interactor?.setPassword(value: password)
        
        presenter?.callback = { passwordWasValidated, _ in
            XCTAssertTrue(passwordWasValidated)
        }
    }
    
    func testEmailValidation() {
        let email = "dsfgdfg"
        interactor?.setEmail(value: email)
        
        presenter?.callback = { _, emailValidationResult in
            XCTAssertFalse(emailValidationResult.result)
        }
    }
    
    func testPasswordValidation() {
        let password = "zfxzxfdfs"
        interactor?.setPassword(value: password)
        
        presenter?.callback = { _, passwordValidationResult in
            XCTAssertFalse(passwordValidationResult.result)
        }
    }
    
    func testEmptyEmailValidation() {
        interactor?.setEmail(value: nil)
        
        presenter?.callback = { _, emailValidationResult in
            XCTAssertFalse(emailValidationResult.result)
        }
    }
    
    func testEmptyPasswordValidation() {
        interactor?.setPassword(value: nil)
        
        presenter?.callback = { _, passwordValidationResult in
            XCTAssertFalse(passwordValidationResult.result)
        }
    }
    
    func testEmailValidationSuccess() {
        let email = "stanislav_marynych@epam.com"
        interactor?.setEmail(value: email)
        
        presenter?.callback = { _, emailValidationResult in
            XCTAssertTrue(emailValidationResult.result)
        }
    }
    
    func testPasswordValidationSuccess() {
        let password = "Qwerty123%"
        interactor?.setPassword(value: password)
        
        presenter?.callback = { _, passwordValidationResult in
            XCTAssertTrue(passwordValidationResult.result)
        }
    }
}
