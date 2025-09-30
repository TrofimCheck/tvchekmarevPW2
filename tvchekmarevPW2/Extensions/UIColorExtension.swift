//
//  UIColorExtension.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 01.10.2025.
//

import UIKit

extension UIColor {
    convenience init?(hex: UInt32) {
        guard hex <= 0xFFFFFF else { return nil }
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
