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

extension PhotoGalleryViewController: UIViewControllerPreviewingDelegate {

    internal func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath)
        else {
            return nil
        }

        if isCameraCompatible && indexPath.row == 0 {
            return nil
        }

        let index = isCameraCompatible ? indexPath.row - 1 : indexPath.row
        let asset = fetchResult[index]
        let detailViewController = PhotoDetailViewController(asset: asset)

        let width = previewingContext.sourceRect.width
        let ratio = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth)
        detailViewController.preferredContentSize = CGSize(width: width, height: width * ratio)
        previewingContext.sourceRect = cell.frame

        return detailViewController
    }

    internal func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // Do nothing
    }

}
