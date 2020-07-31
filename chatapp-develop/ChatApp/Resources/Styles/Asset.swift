//
//  Asset.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/21/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation
import UIKit

protocol AssetFormatter: RawRepresentable {
    var value: UIImage { get }
}

extension AssetFormatter where Self.RawValue == String {
    var value: UIImage {
        guard let image = UIImage(named: self.rawValue) else {
            assertionFailure("UIImage value shouldn`t be nil")
            return UIImage()
        }
        return image
    }
}

enum Asset: String, AssetFormatter {
    case loginHeaderImage
}
