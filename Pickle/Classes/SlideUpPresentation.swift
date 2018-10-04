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

internal final class SlideUpPresentation: NSObject, UIViewControllerTransitioningDelegate {

    internal static let animationDuration = 0.3

    // MARK: - UIViewControllerTransitioningDelegate

    internal func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
    }

    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpPresentingAnimator()
    }

    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideDownDismissingAnimator()
    }

}
