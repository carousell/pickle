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

/// The ImagePickerConfigurable protocol defines the customizable properties of ImagePickerController.
public protocol ImagePickerConfigurable {

    // MARK: - Navigation Item

    /// A custom bar button item displayed on the left (or leading) edge of the navigation bar when the receiver is the top navigation item.
    var cancelBarButtonItem: UIBarButtonItem? { get }

    /// A custom bar button item displayed on the right (or trailing) edge of the navigation bar when the receiver is the top navigation item.
    var doneBarButtonItem: UIBarButtonItem? { get }

    // MARK: - Navigation Bar

    /// The navigation bar style that specifies its appearance.
    var navigationBarStyle: UIBarStyle? { get }

    /// A Boolean value indicating whether the navigation bar is translucent.
    var navigationBarTranslucent: Bool? { get }

    /// The tint color to apply to the navigation items and bar button items.
    var navigationBarTintColor: UIColor? { get }

    /// The navigation bar background color (barTintColor).
    var navigationBarBackgroundColor: UIColor? { get }

    /// The color of navigation bar 1px shadow when the album list is presented.
    var photoAlbumsNavigationBarShadowColor: UIColor? { get }

    // MARK: - Navigation Bar Title View

    /// The font for the navigation title view.
    var navigationBarTitleFont: UIFont? { get }

    /// The tint color of the the navigation title view.
    var navigationBarTitleTintColor: UIColor? { get }

    /// The background color of the navigation title view when selected.
    var navigationBarTitleHighlightedColor: UIColor? { get }

    // MARK: - Status Bar

    /// Specifies whether ImagePickerController prefers the status bar to be hidden or shown.
    var prefersStatusBarHidden: Bool? { get }

    /// The preferred status bar style for ImagePickerController.
    var preferredStatusBarStyle: UIStatusBarStyle? { get }

    /// Specifies the animation style to use for hiding and showing the status bar for ImagePickerController.
    var preferredStatusBarUpdateAnimation: UIStatusBarAnimation? { get }

    // MARK: - Image Selections

    /// The text attributes for the tag on selected images.
    var imageTagTextAttributes: [NSAttributedString.Key: Any]? { get }

    /// The overlay mask color on selected images.
    var selectedImageOverlayColor: UIColor? { get }

    /// Specifies the number of photo selections is allowed in ImagePickerController.
    var allowedSelections: ImagePickerSelection? { get }

    // MARK: - Hint Label

    /// The margin for the text of the hint label.
    var hintTextMargin: UIEdgeInsets? { get }

    // MARK: - Live Camera View

    /// Specifies whether the camera button shows a live preview.
    var isLiveCameraViewEnabled: Bool? { get }

    // MARK: - Media Types

    /// Specifies the supported media types
    var mediaType: ImagePickerMediaType? { get }
}

// Options that represents media type selections in ImagePickerController
public struct ImagePickerMediaType: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Only show images in ImagePickerController
    public static let image = ImagePickerMediaType(rawValue: 1 << 0)

    /// Only show videos in ImagePickerController
    public static let video = ImagePickerMediaType(rawValue: 1 << 1)

    /// Show images and videos in ImagePickerController
    public static let all: ImagePickerMediaType = [.image, .video]
}

/// An enum that represents photo selections allowed in ImagePickerController.
public enum ImagePickerSelection {

    /// Unlimited number of selections.
    case unlimited

    /// Limited selections with an associated number.
    case limit(to: Int)
}
