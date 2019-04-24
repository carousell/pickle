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

internal final class PhotoGalleryHintLabel: UILabel {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpAppearance()
    }

    // MARK: - Properties

    internal var textMargin = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)

    // MARK: - UIView

    override var bounds: CGRect {
        didSet {
            // Shift the layer to show the bottom border.
            borderLayer.frame = bounds.insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -1)
            preferredMaxLayoutWidth = bounds.width
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: contentEdgeInsets.left + size.width + contentEdgeInsets.right,
            height: contentEdgeInsets.top + size.height + contentEdgeInsets.bottom
        )
    }

    override var preferredMaxLayoutWidth: CGFloat {
        get {
            return super.preferredMaxLayoutWidth
        }
        set {
            super.preferredMaxLayoutWidth = newValue - contentEdgeInsets.left - contentEdgeInsets.right
        }
    }

    // MARK: - Private

    private var contentEdgeInsets: UIEdgeInsets {
        return (text?.isEmpty ?? true) ? .zero : textMargin
    }

    private lazy var borderLayer: CALayer = {
        let layer = CALayer()
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.Palette.lightGrey.cgColor
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        return layer
    }()

    private func setUpAppearance() {
        layer.addSublayer(borderLayer)
        clipsToBounds = true

        numberOfLines = 0
        textAlignment = .center
        font = UIFont.forHintLabel
        textColor = UIColor.Palette.grey
    }

}
