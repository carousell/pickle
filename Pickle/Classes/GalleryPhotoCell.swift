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
import Photos

internal class GalleryPhotoCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }

    // MARK: - Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let overlayView = UIView()
    private let tagLabel = PhotoGalleryTagLabel()

    private var taggedText: String? {
        didSet {
            if let text = taggedText {
                overlayView.isHidden = false
                tagLabel.text = text
                accessibilityIdentifier = text
            } else {
                overlayView.isHidden = true
                accessibilityIdentifier = nil
            }
        }
    }

    private var assetLocalID: String?
    private var imageRequestID: PHImageRequestID?

    // MARK: - UITableViewCell

    override func prepareForReuse() {
        super.prepareForReuse()
        assetLocalID = nil
        imageRequestID.map(PHCachingImageManager.default().cancelImageRequest)
        imageRequestID = nil
        taggedText = nil
        imageView.image = nil
    }

    // MARK: -

    internal func configure(with asset: PHAsset, taggedText: String? = nil, configuration: ImagePickerConfigurable?) {
        let size = CGSize(
            width: frame.width * UIScreen.main.scale,
            height: frame.height * UIScreen.main.scale
        )

        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true

        let assetLocalID = asset.localIdentifier
        self.assetLocalID = assetLocalID

        imageRequestID = PHCachingImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            if let image = image, assetLocalID == self?.assetLocalID {
                self?.imageView.image = image
            }
        }

        if let color = configuration?.selectedImageOverlayColor {
            overlayView.backgroundColor = color
        }
        if let textAttributes = configuration?.imageTagTextAttributes {
            tagLabel.textAttributes = textAttributes
        }
        self.taggedText = taggedText
    }

    func setUpSubviews() {
        // Set the cell as the accessibility element for UI tests to work.
        isAccessibilityElement = true

        contentView.backgroundColor = UIColor.lightGray
        overlayView.backgroundColor = UIColor.Palette.blue.withAlphaComponent(0.3)

        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        overlayView.addSubview(tagLabel)

        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        overlayView.frame = contentView.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.widthAnchor.constraint(equalTo: tagLabel.heightAnchor).isActive = true
        tagLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 10).isActive = true
        tagLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -10).isActive = true
    }
}
