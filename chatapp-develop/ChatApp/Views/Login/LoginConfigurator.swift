//
//  LoginConfigurator.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation
import UIKit

final class LoginConfigurator: Configurator {
    static let sharedInstance = LoginConfigurator()
    
    private init() {}
    
    func configure(with viewController: ViewController) {
        guard let viewController = viewController as? LoginViewController else { return }
        
        let router = LoginRouter(rootController: viewController.navigationController ?? UINavigationController())
        let presenter = LoginPresenter(router: router, validationDelegate: ValidationDelegateWrapper(viewController))
        let interactor = LoginInteractor(presenter: presenter, configurationDataProvider: serviceLayer.configurationDataProvider)
        
        viewController.interactor = interactor
    }
}
