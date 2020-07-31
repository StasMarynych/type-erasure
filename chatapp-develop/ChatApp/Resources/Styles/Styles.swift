//
//  Styles.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/21/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import UIKit

protocol ViewControllerWithStyle {
    associatedtype Style
    var style: Style { get }
}

protocol LoginViewControllerStyling {
    var headerImage: UIImage { get }
    var textFieldBorderStyle: UITextField.BorderStyle { get }
    var buttonType: UIButton.ButtonType { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewControllerStyle: LoginViewControllerStyling {
    var headerImage: UIImage { Asset.loginHeaderImage.value }
    var textFieldBorderStyle: UITextField.BorderStyle { .roundedRect }
    var buttonType: UIButton.ButtonType { .roundedRect }
    var buttonTitleColor: UIColor { .systemBlue }
}

extension ViewControllerWithStyle where Self: LoginViewController {
    var style: LoginViewControllerStyling { LoginViewControllerStyle() }
}
