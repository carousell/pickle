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

/// The CameraCompatible protocol defines the required interface of a customized camera view controller to use in ImagePickerController.
public protocol CameraCompatible: class {

    /// The camera view controller's delegate, which should be compatible with UIImagePickerController's delegate.
    var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? { get set }

    /// The UIImagePickerController compatible source type, which is always set to .camera before presenting.
    var sourceType: UIImagePickerController.SourceType { get set }

}

extension UIImagePickerController: CameraCompatible {}
