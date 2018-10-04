//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import Foundation

internal extension UINavigationController {

    internal func configure(with settings: ImagePickerConfigurable?) {
        if let barStyle = settings?.navigationBarStyle {
            navigationBar.barStyle = barStyle
        }

        if let isTranslucent = settings?.navigationBarTranslucent {
            navigationBar.isTranslucent = isTranslucent
        }

        if let barTintColor = settings?.navigationBarTintColor {
            navigationBar.tintColor = barTintColor
        }

        if let backgroundColor = settings?.navigationBarBackgroundColor {
            navigationBar.barTintColor = backgroundColor
        }
    }

}
