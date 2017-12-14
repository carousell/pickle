//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2018 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import UIKit

/// A struct with placeholders that `ImagePickerConfigurable` requires.
public struct Parameters: ImagePickerConfigurable {

    /// Returns a configuration instance with default parameters.
    public init() {}

    // MARK: - Navigation Item

    /// A custom bar button item displayed on the left (or leading) edge of the navigation bar when the receiver is the top navigation item.
    public var cancelBarButtonItem: UIBarButtonItem?

    /// A custom bar button item displayed on the right (or trailing) edge of the navigation bar when the receiver is the top navigation item.
    public var doneBarButtonItem: UIBarButtonItem?

    // MARK: - Navigation Bar

    /// The navigation bar style that specifies its appearance.
    public var navigationBarStyle: UIBarStyle?

    /// A Boolean value indicating whether the navigation bar is translucent.
    public var navigationBarTranslucent: Bool?

    /// The tint color to apply to the navigation items and bar button items.
    public var navigationBarTintColor: UIColor?

    /// The navigation bar background color (barTintColor).
    public var navigationBarBackgroundColor: UIColor?

    /// The color of navigation bar 1px shadow when the album list is presented.
    public var photoAlbumsNavigationBarShadowColor: UIColor?

    // MARK: - Navigation Bar Title View

    /// The font for the navigation title view.
    public var navigationBarTitleFont: UIFont?

    /// The tint color of the the navigation title view.
    public var navigationBarTitleTintColor: UIColor?

    /// The background color of the navigation title view when selected.
    public var navigationBarTitleHighlightedColor: UIColor?

    // MARK: - Status Bar

    /// Specifies whether ImagePickerController prefers the status bar to be hidden or shown.
    public var prefersStatusBarHidden: Bool?

    /// The preferred status bar style for ImagePickerController.
    public var preferredStatusBarStyle: UIStatusBarStyle?

    /// Specifies the animation style to use for hiding and showing the status bar for ImagePickerController.
    public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation?

    // MARK: - Image Selections

    /// The text attributes for the tag on selected images.
    public var imageTagTextAttributes: [NSAttributedStringKey: Any]?

    /// The overlay mask color on selected images.
    public var selectedImageOverlayColor: UIColor?

    /// Specifies the number of photo selections is allowed in ImagePickerController.
    public var allowedSelections: ImagePickerSelection?

    // MARK: - Hint Label

    /// The margin for the text of the hint label.
    public var hintTextMargin: UIEdgeInsets?

}
