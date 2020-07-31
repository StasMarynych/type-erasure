//
//  LoginRouter.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/20/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import UIKit

protocol LoginRouterProtocol {
    func showChatList()
}

class LoginRouter: Router, LoginRouterProtocol {
    override init(rootController: UINavigationController) {
        super.init(rootController: rootController)
    }
    
    func showChatList() {
        let viewController = ChatListViewController()
        viewController.view.backgroundColor = .gray
        setRootViewController(viewController)
    }
}
