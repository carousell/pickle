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

internal final class GalleryVideoCell: GalleryPhotoCell {

    private let videoPropertyView = VideoPropertyView()

    override func setUpSubviews() {
        super.setUpSubviews()

        contentView.addSubview(videoPropertyView)
        videoPropertyView.translatesAutoresizingMaskIntoConstraints = false
        videoPropertyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        videoPropertyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        videoPropertyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        videoPropertyView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }

    override func configure(
        with asset: PHAsset,
        taggedText: String? = nil,
        configuration: ImagePickerConfigurable?) {

        super.configure(
            with: asset,
            taggedText: taggedText,
            configuration: configuration)

        videoPropertyView.configure(duration: asset.duration)
        videoPropertyView.setSelected(taggedText != nil)
    }
}
