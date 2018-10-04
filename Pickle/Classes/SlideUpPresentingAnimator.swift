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

internal final class SlideUpPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SlideUpPresentation.animationDuration
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        let targetFrame = containerView.bounds
        toViewController.view.frame = targetFrame

        // Create a snapshot view for transition animation.
        let snapshotView = toViewController.view.snapshotView(afterScreenUpdates: true)
        let presentedView: UIView = snapshotView ?? toViewController.view

        presentedView.frame = targetFrame.offsetBy(dx: 0, dy: targetFrame.height)
        containerView.addSubview(presentedView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                presentedView.frame = targetFrame
            }, completion: { _ in
                snapshotView?.removeFromSuperview()
                containerView.addSubview(toViewController.view)
                transitionContext.completeTransition(true)
            })
    }

}
