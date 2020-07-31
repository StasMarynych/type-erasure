//
//  Protocols.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation
import UIKit

protocol ViewController where Self: UIViewController {}

extension ViewController {
    func configure(_ viewController: ViewController) {
        switch viewController {
        case is LoginViewController:
            LoginConfigurator.sharedInstance.configure(with: viewController)
        default:
            break
        }
    }
}

fileprivate enum AssociatedKey {
    static var serviceLayerKey = "serviceLayerKey"
}

protocol Configurator: class {
    static var sharedInstance: Self { get }
    func configure(with viewController: ViewController)
}

extension Configurator {
    var serviceLayer: ServiceLayer {
        if let serviceLayer = objc_getAssociatedObject(self, &AssociatedKey.serviceLayerKey) as? ServiceLayer {
            return serviceLayer
        } else {
            let serviceLayer = ServiceLayer()
            objc_setAssociatedObject(self, &AssociatedKey.serviceLayerKey, serviceLayer, .OBJC_ASSOCIATION_RETAIN)
            
            return serviceLayer
        }
    }
}

protocol TapRecognizerControllerProtocol {
    func setupTapRecognizer(dismissKeyboardAction: Selector?, view: UIView?)
}

extension TapRecognizerControllerProtocol where Self: UIViewController {
    func setupTapRecognizer(dismissKeyboardAction: Selector?, view: UIView? = nil) {
        let tapGesture = UITapGestureRecognizer(target: self, action: dismissKeyboardAction)
        tapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        let contentView: UIView = view ?? self.view
        let viewGesture = UITapGestureRecognizer(target: self, action: dismissKeyboardAction)
        viewGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(viewGesture)
    }
}
