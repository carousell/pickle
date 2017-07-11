//
//  Copyright © 2017 Carousell. All rights reserved.
//

import UIKit

internal final class SlideUpPresentationController: UIPresentationController {

    override func presentationTransitionWillBegin() {
        // Calculate the presented frame that doesn't cover the navigation bar.
        let targetFrame: CGRect

        if let navigationBar = presentingViewController.view.subviews.filter({ $0 is UINavigationBar }).first {
            targetFrame = presentingViewController.view.frame.divided(atDistance: navigationBar.frame.maxY, from: .minYEdge).remainder
        } else {
            targetFrame = presentingViewController.view.frame
        }

        containerView?.frame = targetFrame
    }

}
