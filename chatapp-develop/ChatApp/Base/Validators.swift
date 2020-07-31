//
//  Validators.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation

//MARK: - Validation Delegate

protocol ValidationDelegate: class {
    associatedtype ValidationSubject: Hashable
    func setState(_ subjects: [ValidationSubject: ValidationResult])
}

class ValidationDelegateWrapper<ValidationSubject: Hashable>: ValidationDelegate {
    private let _setState: ([ValidationSubject: ValidationResult]) -> Void
    init<Base: ValidationDelegate>(_ base: Base) where ValidationSubject == Base.ValidationSubject {
        _setState = base.setState
    }
    func setState(_ subjects: [ValidationSubject: ValidationResult]) {
        _setState(subjects)
    }
}

//MARK: - Validation Rules

protocol Validating {
    func isValid(value: String?) -> ValidationResult
}

protocol RegexValidator {
    mutating func update(regex: String)
}

typealias RegexValidatorProtocol = Validating & RegexValidator

public enum ValidationResult {
    case passed
    case failed(message: String)
    
    init(_ result: Bool, _ message: @autoclosure () -> String) {
        if result {
            self = .passed
        } else {
            self = .failed(message: message())
        }
    }

    var result: Bool {
        switch self {
        case .passed:
            return true
        case .failed:
            return false
        }
    }
    
    var message: String? {
        switch self {
        case .passed:
            return nil
        case .failed(let message):
            return message
        }
    }
}

struct NotEmptyValidationRule: Validating {
    private var message: String
    
    init(message: String) {
        self.message = message
    }
    
    func isValid(value: String?) -> ValidationResult {
        let unwrappedValue = value ?? ""
        return ValidationResult(!unwrappedValue.isEmpty, message)
    }
}

struct RegexValidationRule: RegexValidatorProtocol {
    private var message: String
    private var regex: String
    
    var title: String {
        return message
    }
    
    init(message: String, regex: String) {
        self.message = message
        self.regex = regex
    }
    
    func isValid(value: String?) -> ValidationResult {
        return ValidationResult(value?.range(of: regex, options: .regularExpression) != nil, message)
    }
    
    mutating func update(regex: String) {
        self.regex = regex
    }
}

// MARK: - Validator

class Validator {
    private var rules: [Validating]
    private let callback: (ValidationResult) -> Void
    
    var result = [ValidationResult(true, .empty)] {
        didSet {
            guard let failure = result.first(where: { $0.result == false }) else { return }
            
            callback(failure)
        }
    }
    
    var isValid: Bool {
        return !result.contains(where: { $0.result == false })
    }
    
    init(rules: [Validating], callback: @escaping (ValidationResult) -> Void) {
        self.rules = rules
        self.callback = callback
    }
    
    func validate(value: String?) {
        result = rules.map { $0.isValid(value: value) }
    }
    
    func add(rule: Validating) {
        rules.append(rule)
    }
}
