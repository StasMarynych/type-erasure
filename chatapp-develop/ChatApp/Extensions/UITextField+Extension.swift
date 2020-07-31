//
//  UITextField+Extension.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/22/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import UIKit

extension UITextField {
    func shake(count: Float = 4, for duration: TimeInterval = 0.5, withTranslation translation: Float = 5) {
        // wll be removed after implementing custom input controls
        let shakingAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shakingAnimation.repeatCount = count
        shakingAnimation.duration = duration / TimeInterval(shakingAnimation.repeatCount)
        shakingAnimation.autoreverses = true
        shakingAnimation.values = [translation, -translation]
        
        UIView.animate(withDuration: duration, animations: {
            self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }) { _ in
            UIView.animate(withDuration: duration) { self.backgroundColor = UIColor.white.withAlphaComponent(1.0) }
        }
        layer.add(shakingAnimation, forKey: "shake")
    }
}
