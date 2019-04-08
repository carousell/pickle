//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2019 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import AVFoundation
import UIKit

final class LiveView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    private var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check LiveView.layerClass implementation.")
        }
        layer.videoGravity = .resizeAspectFill
        return layer
    }

    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
}
