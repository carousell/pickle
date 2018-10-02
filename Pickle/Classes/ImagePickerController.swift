//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

// swiftlint:disable file_length

import UIKit
import Photos

/// Carousell flavoured image picker with multiple photo selections.
@objc
open class ImagePickerController: UINavigationController {

    // MARK: - Initialization

    /// An Objective-C compatible initializer without appearance configuration.
    ///
    /// - Parameter selectedAssets: Preselected image assets that will be highlighted.
    @objc
    public convenience init(selectedAssets: [PHAsset]) {
        self.init(selectedAssets: selectedAssets, configuration: nil)
    }

    /// Returns a newly initialized image picker controller with appearance configuration.
    ///
    /// - Parameters:
    ///   - selectedAssets: Preselected image assets that will be highlighted. Default is an empty array.
    ///   - configuration: Optional appearance configuration. Default is nil.
    public convenience init(selectedAssets: [PHAsset] = [], configuration: ImagePickerConfigurable? = nil) {
        self.init(selectedAssets: selectedAssets, configuration: configuration, cameraType: UIImagePickerController.self)
    }

    /// Returns a newly initialized image picker controller with a customized type of camera.
    ///
    /// - Parameters:
    ///   - selectedAssets: Preselected image assets that will be highlighted.
    ///   - configuration: Optional appearance configuration.
    ///   - cameraType: A UIViewController type that conforms to CameraCompatible protocol.
    public convenience init<T: UIViewController>(
        selectedAssets: [PHAsset],
        configuration: ImagePickerConfigurable?,
        cameraType: T.Type) where T: CameraCompatible {

        self.init(selectedAssets: selectedAssets, configuration: configuration, camera: cameraType.init)
    }

    /// Returns a newly initialized image picker controller with a closure for camera configuration.
    ///
    /// - Parameters:
    ///   - selectedAssets: Preselected image assets that will be highlighted.
    ///   - configuration: Optional appearance configuration.
    ///   - camera: A closure that returns a UIViewController that conforms to CameraCompatible protocol.
    public init<T: UIViewController>(
        selectedAssets: [PHAsset],
        configuration: ImagePickerConfigurable?,
        camera initializer: @escaping () -> T) where T: CameraCompatible {

        self.selectedAssets = selectedAssets
        self.configuration = configuration
        self.allowedSelections = configuration?.allowedSelections ?? .unlimited

        super.init(nibName: nil, bundle: nil)

        if let cancelBarButtonItem = configuration?.cancelBarButtonItem {
            cancelBarButtonItem.target = self
            cancelBarButtonItem.action = #selector(cancel(_:))
            self.cancelBarButton = cancelBarButtonItem
        }

        if let doneBarButtonItem = configuration?.doneBarButtonItem {
            doneBarButtonItem.target = self
            doneBarButtonItem.action = #selector(done(_:))
            self.doneBarButton = doneBarButtonItem
        }

        camera = { [weak self] in
            let camera = initializer()
            camera.sourceType = .camera
            camera.delegate = self
            return camera
        }
    }

    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameters:
    ///   - coder: An unarchiver object.
    public required init?(coder aDecoder: NSCoder) {
        self.selectedAssets = []
        self.configuration = nil
        self.allowedSelections = .unlimited
        super.init(coder: aDecoder)
    }

    // MARK: - Properties

    /// The image picker's delegate object, which should conform to ImagePickerControllerDelegate.
    open override weak var delegate: UINavigationControllerDelegate? {
        didSet {
            imagePickerDelegate = delegate as? ImagePickerControllerDelegate
        }
    }

    /// A localized string that shows on the navigation bar.
    open override var title: String? {
        didSet {
            albumButton.title = title
            albumButton.isHidden = title?.isEmpty ?? true
        }
    }

    /// A localized string that shows above the photos.
    public var hint: NSAttributedString? {
        didSet {
            galleryViewController?.hint = hint
        }
    }

    fileprivate var selectedAssets: [PHAsset]
    fileprivate let configuration: ImagePickerConfigurable?
    fileprivate let allowedSelections: ImagePickerSelection

    fileprivate weak var imagePickerDelegate: ImagePickerControllerDelegate?
    fileprivate lazy var slideUpPresentation: UIViewControllerTransitioningDelegate = SlideUpPresentation()

    fileprivate var galleryViewController: PhotoGalleryViewController? {
        didSet {
            // Remove the reference to the album button from the previous view controller.
            oldValue?.navigationItem.titleView = nil
            guard let galleryViewController = galleryViewController else {
                setViewControllers([], animated: false)
                return
            }
            setViewControllers([galleryViewController], animated: false)
            galleryViewController.hint = hint
            galleryViewController.delegate = self
            galleryViewController.navigationItem.setLeftBarButton(cancelBarButton, animated: true)
            galleryViewController.navigationItem.titleView = albumButton
            galleryViewController.navigationItem.setRightBarButton(doneBarButton, animated: true)
            doneBarButton.isEnabled = !selectedAssets.isEmpty
        }
    }

    fileprivate lazy var camera: () -> UIViewController = {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.delegate = self
        return camera
    }

    fileprivate lazy var emptyViewController: UIViewController = {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        return controller
    }()

    fileprivate lazy var systemPhotoLibraryController: UIViewController = {
        let photoLibrary = UIImagePickerController()
        photoLibrary.sourceType = .photoLibrary
        photoLibrary.configure(with: self.configuration)
        photoLibrary.delegate = self
        return photoLibrary
    }()

    fileprivate lazy var albumButton: PhotoAlbumTitleButton = {
        let button = self.configuration.map(PhotoAlbumTitleButton.init) ?? PhotoAlbumTitleButton()
        button.addTarget(self, action: #selector(togglePhotoAlbums(_:)), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var cancelBarButton: UIBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))

    fileprivate lazy var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
        barButton.isEnabled = false
        return barButton
    }()

    fileprivate lazy var photoAlbums: PHFetchResult<PHAssetCollection> =
        PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)

    fileprivate lazy var favorites: PHFetchResult<PHAssetCollection> =
        PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)

    fileprivate lazy var cameraRoll: PHFetchResult<PHAssetCollection> =
        PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

    /// A closure to present system permission message of photo library when the status is denied or restricted.
    fileprivate var showPermissionErrorIfNeeded: (() -> Void)?

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: configuration)
        setViewControllers([emptyViewController], animated: false)
        handle(photoLibraryPermission: PHPhotoLibrary.authorizationStatus())
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPermissionErrorIfNeeded?()
    }

}


extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UIImagePickerControllerDelegate

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }

        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }

        // Instead of using UIImagePickerControllerEditedImage, crop the original image for higher resolution if UIImagePickerControllerCropRect is specified.
        var croppedImage: UIImage?
        if let cropRect = info[UIImagePickerControllerCropRect] as? CGRect, let cgImage = originalImage.cgImage?.cropping(to: cropRect) {
            croppedImage = UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: croppedImage ?? originalImage)
        }, completionHandler: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied, .restricted:
            picker.dismiss(animated: false) { [weak self] in
                self?.cancel(nil)
            }
        default:
            picker.dismiss(animated: true, completion: nil)
        }
    }

}


// MARK: - PhotoAlbumsViewControllerDelegate


extension ImagePickerController: PhotoAlbumsViewControllerDelegate {

    internal func photoAlbumsViewController(_ controller: PhotoAlbumsViewController, didSelectAlbum album: PHAssetCollection) {
        title = album.localizedTitle
        galleryViewController = PhotoGalleryViewController(album: album, configuration: configuration)
        dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: SlideUpPresentation.animationDuration) {
            self.albumButton.isSelected = false
        }
    }

}


// MARK: - PhotoGalleryViewControllerDelegate


extension ImagePickerController: PhotoGalleryViewControllerDelegate {

    internal func photoGalleryViewController(_ controller: PhotoGalleryViewController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return imagePickerDelegate?.imagePickerController(self, shouldLaunchCameraWithAuthorization: status) ?? true
    }

    internal func photoGalleryViewController(_ controller: PhotoGalleryViewController, shouldTogglePhoto asset: PHAsset) -> Bool {
        if selectedAssets.index(of: asset) != nil {
            return true
        }

        switch allowedSelections {
        case .limit(to: let number) where 1 < number:
            return selectedAssets.count < number
        default:
            return true
        }
    }

    internal func photoGalleryViewController(_ controller: PhotoGalleryViewController, didTogglePhoto asset: PHAsset) {
        if let selectedIndex = selectedAssets.index(of: asset) {
            selectedAssets.remove(at: selectedIndex)
            imagePickerDelegate?.imagePickerController?(self, didDeselectImageAsset: asset)
        } else {
            switch allowedSelections {
            case .limit(to: let number) where 1 < number && selectedAssets.count < number:
                fallthrough // swiftlint:disable:this no_fallthrough_only
            case .unlimited:
                selectedAssets.append(asset)
                imagePickerDelegate?.imagePickerController?(self, didSelectImageAsset: asset)
            case .limit(to: let number) where number == 1:
                // When selecting only 1 photo, replace the selected one on every tap.
                selectedAssets = [asset]
                imagePickerDelegate?.imagePickerController?(self, didSelectImageAsset: asset)
            default:
                break
            }
        }
        doneBarButton.isEnabled = !selectedAssets.isEmpty
    }

    internal func photoGalleryViewController(_ controller: PhotoGalleryViewController, taggedTextForPhoto asset: PHAsset) -> String? {
        guard let index = selectedAssets.index(of: asset) else {
            return nil
        }

        switch allowedSelections {
        case .limit(to: let number) where number == 1:
            return "✔︎"
        default:
            return String(index + 1)
        }
    }

    internal func photoGalleryViewControllerDidSelectCameraButton(_ controller: PhotoGalleryViewController) {
        launchCamera()
    }

}


// MARK: - Private


fileprivate extension ImagePickerController {

    fileprivate func handle(photoLibraryPermission status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    self.handle(photoLibraryPermission: status)
                    self.showPermissionErrorIfNeeded?()
                }
            }

        case .authorized:
            title = cameraRoll.firstObject?.localizedTitle
            galleryViewController = PhotoGalleryViewController(album: cameraRoll.firstObject, configuration: configuration)

        case .denied, .restricted:
            // Workaround the issue in iOS 11 where UIImagePickerController doesn't show the permission denied message.
            // It requires additional PHAuthorizationStatus check before presenting Pickle.ImagePickerController.
            if #available(iOS 11.0, *) {
                // Hide the album button and display an empty gallery with a cancel button to dismiss the image picker.
                title = nil
                galleryViewController = PhotoGalleryViewController()
                return
            }
            let controller = systemPhotoLibraryController
            showPermissionErrorIfNeeded = { [weak self] in
                self?.present(controller, animated: false, completion: {
                    self?.showPermissionErrorIfNeeded = nil
                })
            }
        }
    }

    fileprivate func launchCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        guard imagePickerDelegate?.imagePickerController(self, shouldLaunchCameraWithAuthorization: status) ?? true else {
            return
        }

        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { _ in
                DispatchQueue.main.async {
                    self.launchCamera()
                }
            }
        default:
            present(camera(), animated: true, completion: nil)
        }
    }

    private func transitioningDelegate(for controller: PhotoAlbumsViewController) -> UIViewControllerTransitioningDelegate {
        if let transitioningDelegate = imagePickerDelegate?.imagePickerController?(self, transitioningDelegateForPresentingAlbumsViewController: controller) {
            slideUpPresentation = transitioningDelegate
        }
        return slideUpPresentation
    }

    // MARK: IBActions

    @objc
    fileprivate func togglePhotoAlbums(_ sender: UIControl) {
        let showsPhotoAlbums = !sender.isSelected

        if showsPhotoAlbums {
            let albums = imagePickerDelegate?.photoAlbumsForImagePickerController?(self) ?? [cameraRoll, favorites, photoAlbums]
            let controller = PhotoAlbumsViewController(source: albums, configuration: configuration)
            controller.delegate = self
            controller.title = title
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = transitioningDelegate(for: controller)
            present(controller, animated: true, completion: nil)
        } else {
            presentedViewController?.dismiss(animated: true, completion: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Remove the animation on the navigation bar added by system during modal presentation.
            self.navigationBar.layer.removeAllAnimations()
            UIView.animate(withDuration: SlideUpPresentation.animationDuration) {
                sender.isSelected = showsPhotoAlbums
            }

            self.galleryViewController?.navigationItem.setLeftBarButton(showsPhotoAlbums ? nil : self.cancelBarButton, animated: true)
            self.galleryViewController?.navigationItem.setRightBarButton(showsPhotoAlbums ? nil : self.doneBarButton, animated: true)
        }
    }

    @objc
    fileprivate func cancel(_ sender: UIBarButtonItem?) {
        imagePickerDelegate?.imagePickerControllerDidCancel(self)
    }

    @objc
    fileprivate func done(_ sender: UIBarButtonItem) {
        imagePickerDelegate?.imagePickerController(self, didFinishPickingImageAssets: selectedAssets)
    }

}
// swiftlint:enable
