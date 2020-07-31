//
//  UINavigationController+Extension.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: EmptyClosure? = nil) {
        pushViewController(viewController, animated: animated)
        
        guard let completion = completion else { return }
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: EmptyClosure?) {
        popViewController(animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion?() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
}
