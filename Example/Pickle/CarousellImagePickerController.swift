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
import Pickle
import Photos

internal class CarousellImagePickerController: ImagePickerController {

    internal init() {
        super.init(
            selectedAssets: [],
            configuration: CarousellTheme(),
            camera: UIImagePickerController.init
        )

        hint = {
            let titleStyle = NSMutableParagraphStyle()
            titleStyle.maximumLineHeight = 42
            titleStyle.minimumLineHeight = 42
            titleStyle.paragraphSpacing = 4
            titleStyle.firstLineHeadIndent = 12
            titleStyle.alignment = .left

            let subtitleStyle = NSMutableParagraphStyle()
            subtitleStyle.maximumLineHeight = 12
            subtitleStyle.minimumLineHeight = 12
            subtitleStyle.paragraphSpacing = 10
            subtitleStyle.firstLineHeadIndent = 12
            subtitleStyle.alignment = .left

            let title = NSMutableAttributedString(
                string: "What are you listing?\n",
                attributes: [
                    NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22),
                    NSForegroundColorAttributeName: UIColor.black,
                    NSBackgroundColorAttributeName: UIColor.white,
                    NSParagraphStyleAttributeName: titleStyle
                ]
            )

            let subtitle = NSAttributedString(
                string: "You can choose up to 4 photos for your listing.\n",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                    NSForegroundColorAttributeName: UIColor.darkGray,
                    NSBackgroundColorAttributeName: UIColor.white,
                    NSParagraphStyleAttributeName: subtitleStyle
                ]
            )

            title.append(subtitle)
            return title
        }()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


private struct CarousellTheme: ImagePickerConfigurable {

    // MARK: - Navigation Bar

    let navigationBarStyle: UIBarStyle? = .blackTranslucent
    let navigationBarTranslucent: Bool? = false
    let navigationBarTintColor: UIColor? = .white
    let navigationBarBackgroundColor: UIColor? = UIColor(red: 0xD2 / 255.0, green: 0x23 / 255.0, blue: 0x2A / 255.0, alpha: 1)
    let photoAlbumsNavigationBarShadowColor: UIColor? = .clear

    // MARK: - Navigation Bar Title View

    let navigationBarTitleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    let navigationBarTitleTintColor: UIColor? = .white
    let navigationBarTitleHighlightedColor: UIColor? = UIColor(red: 0x9E / 255.0, green: 0x0D / 255.0, blue: 0x11 / 255.0, alpha: 1)

    // MARK: - Status Bar

    let prefersStatusBarHidden: Bool? = false
    let preferredStatusBarStyle: UIStatusBarStyle? = .lightContent
    let preferredStatusBarUpdateAnimation: UIStatusBarAnimation? = .fade

    // MARK: - Image Selections

    var imageTagTextAttributes: [String: Any]? = nil
    var selectedImageOverlayColor: UIColor? = nil
    let allowedSelections: ImagePickerSelection? = .limit(to: 4)

    // MARK: -

    let hintTextMargin: UIEdgeInsets? = .zero

}
