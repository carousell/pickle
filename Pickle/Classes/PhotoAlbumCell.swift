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

internal final class PhotoAlbumCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }

    // MARK: - Properties

    private let imageViews = [UIImageView(), UIImageView(), UIImageView()].map {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isHidden = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 0.5
        return $0
    } as [UIImageView]

    private lazy var titleLabel = UILabel()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Palette.grey
        return label
    }()

    private var imageRequestIDs: [PHImageRequestID] = []

    // MARK: - UITableViewCell

    override func prepareForReuse() {
        super.prepareForReuse()
        for id in imageRequestIDs {
            PHCachingImageManager.default().cancelImageRequest(id)
        }
        imageRequestIDs = []
        imageViews.forEach { $0.image = nil }
    }

    // MARK: -

    internal func configure(with album: PHAssetCollection) {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

        let fetchResult = PHAsset.fetchAssets(in: album, options: options)
        let imageSize = CGSize(
            width: frame.height * UIScreen.main.scale,
            height: frame.height * UIScreen.main.scale
        )

        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.isNetworkAccessAllowed = true

        titleLabel.text = album.localizedTitle
        subtitleLabel.text = String(fetchResult.count)

        fetchResult.enumerateObjects({ asset, index, stop in
            if index > 2 {
                stop.initialize(to: true)
                return
            }

            let id = PHCachingImageManager.default().requestImage(
                for: asset,
                targetSize: imageSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { [weak self] image, _ in
                if let image = image {
                    self?.imageViews[index].image = image
                    self?.imageViews[index].isHidden = false
                }
            }
            self.imageRequestIDs.append(id)
        })
    }

    private func setUpSubviews() {
        accessoryType = .disclosureIndicator
        textLabel?.removeFromSuperview()
        detailTextLabel?.removeFromSuperview()

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        imageViews.forEach {
            contentView.addSubview($0)
            contentView.sendSubviewToBack($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        imageViews[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        imageViews[0].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        imageViews[0].bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        imageViews[0].widthAnchor.constraint(equalTo: imageViews[0].heightAnchor).isActive = true

        for (index, imageView) in imageViews.enumerated() {
            guard index != 0 else {
                continue
            }
            imageView.widthAnchor.constraint(equalTo: imageViews[0].widthAnchor, constant: -2 * CGFloat(index)).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageViews[0].heightAnchor, constant: -2 * CGFloat(index)).isActive = true
            imageView.centerXAnchor.constraint(equalTo: imageViews[0].centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: imageViews[0].centerYAnchor, constant: -4 * CGFloat(index)).isActive = true
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: imageViews[0].trailingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 15).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.leadingAnchor.constraint(equalTo: imageViews[0].trailingAnchor, constant: 15).isActive = true
        subtitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 15).isActive = true
        subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10).isActive = true
    }

}
