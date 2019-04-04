//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2019 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import Foundation
import AVFoundation
import UIKit

final class PhotoGalleryLiveViewCell: UICollectionViewCell {

    private let previewView = LiveView()
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "pickle.liveView.sessionQueue")

    private lazy var cameraIconView: UIImageView = {
        let camera = UIImage(named: "camera-icon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        return UIImageView(image: camera)
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = Bundle(for: type(of: self)).localizedString(forKey: "imagePicker.button.camera", value: "", table: nil).uppercased()
        label.font = UIFont.forCameraButton
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        startSession()
    }

    private func setupViews() {
        isAccessibilityElement = true

        contentView.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        previewView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        previewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        contentView.addSubview(cameraIconView)
        contentView.addSubview(textLabel)

        cameraIconView.translatesAutoresizingMaskIntoConstraints = false
        cameraIconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cameraIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: cameraIconView.bottomAnchor, constant: 10).isActive = true
    }

    private func startSession() {
        let permission = AVCaptureDevice.authorizationStatus(for: .video)
        guard permission == .authorized else {
            previewView.removeFromSuperview()
            contentView.backgroundColor = UIColor.Palette.lightGray
            return
        }
        guard
            let input = AVCaptureDevice.default(for: .video),
            let deviceInput = try? AVCaptureDeviceInput(device: input) else {
                return
        }
        previewView.session = session
        session.addInput(deviceInput)
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
