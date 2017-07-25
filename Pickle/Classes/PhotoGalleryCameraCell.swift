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

internal final class PhotoGalleryCameraCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }

    private lazy var cameraIconView: UIView = PhotoGalleryCameraIconView()

    private func setUpSubviews() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(cameraIconView)

        cameraIconView.translatesAutoresizingMaskIntoConstraints = false
        cameraIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cameraIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cameraIconView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cameraIconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

}
