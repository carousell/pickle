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

/// The ImagePickerControllerDelegate protocol defines methods that interact with the image picker interface.
/// The delegate is responsible for dismissing the picker when the operation completes.
@objc
public protocol ImagePickerControllerDelegate: UINavigationControllerDelegate {

    /// Asks the delegate if the image picker should launch camera with certain permission status.
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool

    /// Tells the delegate that the user picked image assets.
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset])

    /// Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: ImagePickerController)

    /// Optional. Asks the delegate for the photo album list to display. The image picker shows the camera roll and non-smart albums if not implemented.
    @objc optional func photoAlbumsForImagePickerController(_ picker: ImagePickerController) -> [PHFetchResult<PHAssetCollection>]

    /// Optional. Asks the delegate for the transitioning delegate for presenting the album list. The default transition is used if not implemented.
    @objc optional func imagePickerController(_ picker: ImagePickerController, transitioningDelegateForPresentingAlbumsViewController controller: UIViewController) -> UIViewControllerTransitioningDelegate

    /// Optional. Tells the delegate that the user selected an image asset.
    @objc optional func imagePickerController(_ picker: ImagePickerController, didSelectImageAsset asset: PHAsset)

    /// Optional. Tells the delegate that the user deselected an image asset.
    @objc optional func imagePickerController(_ picker: ImagePickerController, didDeselectImageAsset asset: PHAsset)
}
