//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import UIKit

internal extension UIColor {

    internal enum Palette {
        static let blue = UIColor(hex: 0x2984C0)
        static let lightGrey = UIColor(hex: 0x8F939C)
        static let grey = UIColor(hex: 0x8F939C)
        static let magnesium = UIColor(hex: 0xB2B2B2)
        static let darkGrey = UIColor(hex: 0x4B4D52)
    }

    internal convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255,
            blue: CGFloat(hex & 0x0000FF) / 255,
            alpha: 1
        )
    }

}
