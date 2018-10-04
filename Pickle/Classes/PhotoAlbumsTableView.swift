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

internal final class PhotoAlbumsTableView: UITableView {

    // MARK: - Initialization

    internal convenience init(configuration: ImagePickerConfigurable? = nil) {
        self.init(frame: .zero, style: .plain)

        let color = configuration?.photoAlbumsNavigationBarShadowColor
        guard color != .clear else {
            return
        }

        layer.addSublayer(shadawLayer)
        shadawLayer.borderColor = color?.cgColor ?? UIColor.Palette.magnesium.cgColor
    }

    // MARK: - Properties

    private var _shadawLayer: CALayer?

    private var shadawLayer: CALayer {
        if let instantiated = _shadawLayer {
            return instantiated
        }

        let layer = CALayer()
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true

        _shadawLayer = layer
        return layer
    }

    // MARK: - UIView

    override var frame: CGRect {
        didSet {
            _shadawLayer?.frame = bounds.insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: 1)
        }
    }

}
