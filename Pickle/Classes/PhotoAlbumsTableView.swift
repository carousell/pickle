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

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        layer.addSublayer(shadawLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(shadawLayer)
    }

    // MARK: - Properties

    private lazy var shadawLayer: CALayer = {
        let layer = CALayer()
        layer.borderColor = UIColor.Palette.magnesium.cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        return layer
    }()

    // MARK: - UIView

    override var frame: CGRect {
        didSet {
            shadawLayer.frame = bounds.insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: 1)
        }
    }

}
