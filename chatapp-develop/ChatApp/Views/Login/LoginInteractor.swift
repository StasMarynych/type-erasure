//
//  LoginInteractor.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation

protocol LoginInteractorProtocol {
    func setEmail(value: String?)
    func setPassword(value: String?)
    func setup()
    func login()
}

class LoginInteractor: LoginInteractorProtocol {
    private let presenter: LoginPresenterProtocol
    private let configurationDataProvider: ConfigurationDataProviderProtocol
    
    private var email: String? = .empty {
        didSet {
            emailValidator.validate(value: email)
        }
    }
    private var password: String? = .empty {
        didSet {
            passwordValidator.validate(value: password)
        }
    }
    
    private lazy var emailValidator = Validator(rules: []) { [weak self] result in
        self?.presenter.setEmailsState(result: result)
    }
    private lazy var passwordValidator = Validator(rules: []) { [weak self] result in
        self?.presenter.setPasswordsState(result: result)
    }
    
    init(presenter: LoginPresenterProtocol, configurationDataProvider: ConfigurationDataProviderProtocol) {
        self.presenter = presenter
        self.configurationDataProvider = configurationDataProvider
    }
    
    func setup() {
        setupValidationRules()
    }
    
    func setEmail(value: String?) {
        email = value
    }
    
    func setPassword(value: String?) {
        password = value
    }
    
    func areFieldsValid() -> Bool {
        return emailValidator.isValid && passwordValidator.isValid
    }
    
    func login() {
        guard areFieldsValid() else { return }
        
        presenter.successfullogin()
    }
    
    private func setupValidationRules() {
        configurationDataProvider.getConfig { [weak self] config in
            guard let emailRegex = config[ConfigurationKeys.validationRuleEmail],
                let passwordRegex = config[ConfigurationKeys.validationRulePassword] else { return }
            
            //will be fixed after integrating Applanga
            self?.emailValidator.add(rule: NotEmptyValidationRule(message: ""))
            self?.emailValidator.add(rule: RegexValidationRule(message: "", regex: emailRegex))
            
            self?.passwordValidator.add(rule: NotEmptyValidationRule(message: ""))
            self?.passwordValidator.add(rule: RegexValidationRule(message: "", regex: passwordRegex))
        }
    }
}
