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

internal final class SlideDownDismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SlideUpPresentation.animationDuration
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let currentFrame = fromViewController.view.frame
        let finalFrame = currentFrame.offsetBy(dx: 0, dy: currentFrame.height)

        // Create a snapshot view for transition animation.
        let containerView = transitionContext.containerView
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: true)
        let presentedView: UIView = snapshotView ?? fromViewController.view

        fromViewController.view.removeFromSuperview()
        presentedView.frame = currentFrame
        containerView.addSubview(presentedView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                presentedView.frame = finalFrame
            }, completion: { _ in
                presentedView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }

}
