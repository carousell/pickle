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

internal final class SlideUpPresentationController: UIPresentationController {

    override func presentationTransitionWillBegin() {
        adjustContainerFrame()
    }

    // MARK: - UITraitEnvironment

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection != nil {
            // Update the frame for the container view after device rotation.
            adjustContainerFrame()
        }
    }

    // MARK: - Private

    private func adjustContainerFrame() {
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
