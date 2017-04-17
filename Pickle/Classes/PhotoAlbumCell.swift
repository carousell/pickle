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

internal class PhotoAlbumCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        label.textColor = UIColor.Palette.gray
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

            let id = PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: requestOptions) {
                if let image = $0.0 {
                    self.imageViews[index].image = image
                    self.imageViews[index].isHidden = false
                }
            }
            self.imageRequestIDs.append(id)
        })
    }

    // swiftlint:disable function_body_length
    private func setUpSubviews() {
        accessoryType = .disclosureIndicator
        textLabel?.removeFromSuperview()
        detailTextLabel?.removeFromSuperview()

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        imageViews.forEach {
            contentView.addSubview($0)
            contentView.sendSubview(toBack: $0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        if #available(iOS 9.0, *) {
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
        } else {
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-15-[image]",
                options: [],
                metrics: nil,
                views: ["image": imageViews[0]]
            ))
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-10-[image]-10-|",
                options: [],
                metrics: nil,
                views: ["image": imageViews[0]]
            ))
            imageViews[0].addConstraint(NSLayoutConstraint(
                item: imageViews[0],
                attribute: .width,
                relatedBy: .equal,
                toItem: imageViews[0],
                attribute: .height,
                multiplier: 1,
                constant: 0
            ))

            for (index, imageView) in imageViews.enumerated() {
                guard index != 0 else {
                    continue
                }

                contentView.addConstraint(NSLayoutConstraint(
                    item: imageView,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: imageViews[0],
                    attribute: .width,
                    multiplier: 1,
                    constant: -2 * CGFloat(index)
                ))
                contentView.addConstraint(NSLayoutConstraint(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: imageViews[0],
                    attribute: .height,
                    multiplier: 1,
                    constant: -2 * CGFloat(index)
                ))
                contentView.addConstraint(NSLayoutConstraint(
                    item: imageView,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: imageViews[0],
                    attribute: .centerX,
                    multiplier: 1,
                    constant: 0
                ))
                contentView.addConstraint(NSLayoutConstraint(
                    item: imageView,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: imageViews[0],
                    attribute: .centerY,
                    multiplier: 1,
                    constant: -4 * CGFloat(index)
                ))
            }
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 9.0, *) {
            titleLabel.leadingAnchor.constraint(equalTo: imageViews[0].trailingAnchor, constant: 15).isActive = true
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 15).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true

            subtitleLabel.leadingAnchor.constraint(equalTo: imageViews[0].trailingAnchor, constant: 15).isActive = true
            subtitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 15).isActive = true
            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10).isActive = true
        } else {
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:[image]-15-[title]-(>=15)-|",
                options: [],
                metrics: nil,
                views: ["image": imageViews[0], "title": titleLabel]
            ))
            contentView.addConstraint(NSLayoutConstraint(
                item: titleLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .centerY,
                multiplier: 1,
                constant: -10
            ))

            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:[image]-15-[subtitle]-(>=15)-|",
                options: [],
                metrics: nil,
                views: ["image": imageViews[0], "subtitle": subtitleLabel]
            ))
            contentView.addConstraint(NSLayoutConstraint(
                item: subtitleLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .centerY,
                multiplier: 1,
                constant: 10
            ))
        }
    }
    // swiftlint:enable

}
