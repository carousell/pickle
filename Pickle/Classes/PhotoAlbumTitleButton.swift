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

internal final class PhotoAlbumTitleButton: UIControl {

    private struct Configuration {
        let font: UIFont?
        let tintColor: UIColor?
        let highlightedColor: UIColor?

        init(font: UIFont?, tintColor: UIColor?, highlightedColor: UIColor?) {
            self.font = font
            self.tintColor = tintColor ?? Configuration.systemTintColor
            self.highlightedColor = highlightedColor ?? Configuration.systemTintColor
        }

        private static let systemTintColor = UIButton().tintColor
    }

    // MARK: - Initialization

    internal init(configuration settings: ImagePickerConfigurable) {
        super.init(frame: .zero)
        self.configuration = Configuration(
            font: settings.navigationBarTitleFont,
            tintColor: settings.navigationBarTitleTintColor,
            highlightedColor: settings.navigationBarTitleHighlightedColor
        )
        setUpSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            // Force the rotating direction by a slight offset from π.
            let pi = CGFloat.pi - 0.01
            if isSelected {
                backgroundColor = configuration.highlightedColor
                titleLabel.textColor = UIColor.white
                arrowIcon.tintColor = UIColor.white
                arrowIcon.transform = arrowIcon.transform.rotated(by: -pi)
            } else {
                backgroundColor = UIColor.clear
                titleLabel.textColor = configuration.tintColor
                arrowIcon.tintColor = configuration.tintColor
                arrowIcon.transform = CGAffineTransform.identity
            }
        }
    }

    internal var title: String? {
        didSet {
            titleLabel.text = title
            frame = CGRect(origin: frame.origin, size: systemLayoutSizeFitting(UIView.layoutFittingCompressedSize))
        }
    }

    private lazy var configuration: Configuration = Configuration(
        font: nil,
        tintColor: self.tintColor,
        highlightedColor: self.tintColor
    )

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = self.configuration.tintColor
        label.font = self.configuration.font
        return label
    }()

    private lazy var arrowIcon: UIImageView = {
        let icon = UIImageView()
        let image = UIImage(named: "image-picker-down-arrow", in: Bundle(for: type(of: self)), compatibleWith: nil)
        icon.image = image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = self.configuration.tintColor
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFill
        return icon
    }()

    // MARK: - Private

    private func setUpSubviews() {
        layer.cornerRadius = 4

        addSubview(titleLabel)
        addSubview(arrowIcon)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        arrowIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5).isActive = true
        arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: arrowIcon.centerYAnchor).isActive = true
    }

}
