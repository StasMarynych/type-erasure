//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, ViewController, ViewControllerWithStyle {
    private enum Consts {
        enum Layout {
            static let headerHeight: CGFloat = 210
            static let minOffsetY: CGFloat = 0.8
            static let spacing: CGFloat = 30
            static let stackViewInsets = UIEdgeInsets(top: 100, left: 40, bottom: 100, right: 40)
            static let stackViewWidthMultiplier: CGFloat = 0.8
        }
        
        static let parallaxFactor: CGFloat = 0.25
    }
    
    typealias Style = LoginViewControllerStyling
    
    var interactor: LoginInteractorProtocol?
    
    private lazy var scrollView = UIScrollView()
    private lazy var headerContainerView = UIView()
    private lazy var headerImageView = UIImageView()
    
    private lazy var headerTopConstraint = NSLayoutConstraint()
    private lazy var headerHeightConstraint = NSLayoutConstraint()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextFiled, loginButton])
    private lazy var emailTextField = UITextField()
    private lazy var passwordTextFiled = UITextField()
    private lazy var loginButton = UIButton(type: style.buttonType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(self)
        setup()
        interactor?.setup()
    }
    
    private func setup() {
        setupSubviews()
        setupLocalization()
        setupStyle()
        setupAutolayout()
        setupActions()
    }
    
    private func setupSubviews() {
        navigationController?.navigationBar.isHidden = true
        
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        
        headerContainerView.clipsToBounds = true
        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = Consts.Layout.spacing
        
        headerContainerView.addSubview(headerImageView)
        scrollView.addSubview(headerContainerView)
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
    }
    
    private func setupLocalization() {
        // will be fixed after integrating Applanga
        loginButton.setTitle("Login", for: .normal)
        emailTextField.placeholder = "Email"
        passwordTextFiled.placeholder = "Password"
    }
    
    private func setupStyle() {
        headerImageView.image = style.headerImage
        
        loginButton.setTitleColor(style.buttonTitleColor, for: .normal)
        
        emailTextField.borderStyle = style.textFieldBorderStyle
        passwordTextFiled.borderStyle = style.textFieldBorderStyle
        
        loginButton.setTitleColor(style.buttonTitleColor, for: .normal)
    }
    
    private func setupAutolayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFiled.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerTopConstraint = headerContainerView.topAnchor
            .constraint(equalTo: view.topAnchor)
        headerHeightConstraint = headerContainerView.heightAnchor
            .constraint(equalToConstant: Consts.Layout.headerHeight)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerTopConstraint,
            headerHeightConstraint,
            headerContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerImageView.leftAnchor.constraint(equalTo: headerContainerView.leftAnchor),
            headerImageView.rightAnchor.constraint(equalTo: headerContainerView.rightAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: Consts.Layout.stackViewInsets.top),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: Consts.Layout.stackViewInsets.left),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -Consts.Layout.stackViewInsets.right),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Consts.Layout.stackViewInsets.bottom),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: Consts.Layout.stackViewWidthMultiplier),
        ])
    }
    
    private func setupActions() {
        setupTapRecognizer(dismissKeyboardAction: #selector(dismissKeyboard))
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc func login() {
        // will be removed after implementing `lostFocus` functionality
        interactor?.setEmail(value: emailTextField.text)
        interactor?.setPassword(value: passwordTextFiled.text)
        
        interactor?.login()
    }
    
    @objc func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextFiled.resignFirstResponder()
    }
}


//MARK: - ValidationDelegate
extension LoginViewController: ValidationDelegate {
    enum Subjects {
        case email
        case password
    }
    
    typealias ValidationSubject = Subjects
    
    func setState(_ subjects: [Subjects : ValidationResult]) {
        subjects.forEach { error in
            switch error.key {
            case .email:
                // will be fixed
                emailTextField.shake()
            case .password:
                // will be fixed
                passwordTextFiled.shake()
            }
        }
    }
}

//MARK: - UIScrollViewDelegate
extension LoginViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            headerHeightConstraint.constant =
                Consts.Layout.headerHeight - scrollView.contentOffset.y
        } else {
            let parallaxFactor: CGFloat = Consts.parallaxFactor
            let offsetY = scrollView.contentOffset.y * parallaxFactor
            let minOffsetY: CGFloat = Consts.Layout.minOffsetY
            let availableOffset = min(offsetY, minOffsetY)
            let contentRectOffsetY = availableOffset / Consts.Layout.headerHeight
            headerTopConstraint.constant = view.frame.origin.y
            headerHeightConstraint.constant =
                Consts.Layout.headerHeight - scrollView.contentOffset.y
            headerImageView.layer.contentsRect =
                CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
        }
    }
}

// MARK: - TapRecognizerControllerProtocol

extension LoginViewController: TapRecognizerControllerProtocol {}
