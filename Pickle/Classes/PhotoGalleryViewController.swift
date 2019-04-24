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
import Photos

internal protocol PhotoGalleryViewControllerDelegate: class {
    func photoGalleryViewController(_ controller: PhotoGalleryViewController, shouldTogglePhoto asset: PHAsset) -> Bool
    func photoGalleryViewController(_ controller: PhotoGalleryViewController, didTogglePhoto asset: PHAsset)
    func photoGalleryViewController(_ controller: PhotoGalleryViewController, taggedTextForPhoto asset: PHAsset) -> String?
    func photoGalleryViewControllerDidSelectCameraButton(_ controller: PhotoGalleryViewController)
}


internal final class PhotoGalleryViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    PHPhotoLibraryChangeObserver {

    internal init(album: PHAssetCollection? = nil, configuration: ImagePickerConfigurable? = nil) {
        self.album = album ?? PHAssetCollection()
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        PHPhotoLibrary.shared().register(self)
    }

    required init?(coder aDecoder: NSCoder) {
        self.album = PHAssetCollection()
        self.configuration = nil
        super.init(coder: aDecoder)
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    // MARK: - Properties

    weak var delegate: PhotoGalleryViewControllerDelegate?

    internal var hint: NSAttributedString? {
        get {
            return hintLabel.attributedText
        }
        set {
            hintLabel.attributedText = newValue
            if let margin = configuration?.hintTextMargin {
                hintLabel.textMargin = margin
            }
            if let color = newValue?.attributes?[.backgroundColor] as? UIColor {
                hintLabel.backgroundColor = color
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return configuration?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return configuration?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return configuration?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }

    private var sessionHandler: CameraSessionHandler?
    private let album: PHAssetCollection
    private let configuration: ImagePickerConfigurable?
    internal private(set) lazy var isCameraCompatible: Bool = self.album.isCameraCompatible

    internal private(set) lazy var fetchResult: PHFetchResult<PHAsset> = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        switch configuration?.mediaType {
        case .all?:
            options.predicate = nil
        case .image?:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        case .video?:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        default:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        }

        return PHAsset.fetchAssets(in: self.album, options: options)
    }()

    private lazy var hintLabel: PhotoGalleryHintLabel = PhotoGalleryHintLabel()

    private var _emptyView: UIView?

    private var emptyView: UIView {
        if let instantiated = _emptyView {
            return instantiated
        }

        let emptyView = PhotoGalleryCameraIconView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchCamera(withTapGesture:)))
        emptyView.addGestureRecognizer(tapRecognizer)
        _emptyView = emptyView
        return emptyView
    }

    internal private(set) lazy var collectionView: UICollectionView = {
        let layout = self.photoGalleryLayout(for: UIScreen.main.bounds.size)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(PhotoGalleryCameraCell.self, forCellWithReuseIdentifier: String(describing: PhotoGalleryCameraCell.self))
        collectionView.register(GalleryPhotoCell.self, forCellWithReuseIdentifier: String(describing: GalleryPhotoCell.self))
        collectionView.register(GalleryVideoCell.self, forCellWithReuseIdentifier: String(describing: GalleryVideoCell.self))
        collectionView.register(PhotoGalleryLiveViewCell.self, forCellWithReuseIdentifier: String(describing: PhotoGalleryLiveViewCell.self))
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        showEmptyViewIfNeeded()
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        if configuration?.isLiveCameraViewEnabled == .some(true) {
            sessionHandler = try? CameraSessionHandler()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sessionHandler?.stopSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? sessionHandler?.startSession()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout = photoGalleryLayout(for: size)
    }

    // MARK: - UICollectionViewDataSource

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCameraCompatible ? fetchResult.count + 1 : fetchResult.count
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCameraCompatible && indexPath.row == 0 {
            if sessionHandler?.hasPermssion == .some(true) {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: PhotoGalleryLiveViewCell.self),
                    for: indexPath
                )
                sessionHandler?.previewView = (cell as? PhotoGalleryLiveViewCell)?.previewView
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoGalleryCameraCell.self), for: indexPath)
                return cell
            }
        }

        let index = isCameraCompatible ? indexPath.row - 1 : indexPath.row
        let asset = fetchResult[index]

        let text = delegate?.photoGalleryViewController(self, taggedTextForPhoto: asset)
        var cell: UICollectionViewCell
        if asset.mediaType == .video {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryVideoCell.self), for: indexPath)
            (cell as? GalleryVideoCell)?.configure(with: asset, taggedText: text, configuration: configuration)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryPhotoCell.self), for: indexPath)
            (cell as? GalleryPhotoCell)?.configure(with: asset, taggedText: text, configuration: configuration)
        }

        if text != nil {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }

        return cell
    }

    // MARK: - UICollectionViewDelegate

    private func shouldToggleTaggedItem(at indexPath: IndexPath) -> Bool {
        if isCameraCompatible && indexPath.row == 0 {
            delegate?.photoGalleryViewControllerDidSelectCameraButton(self)
            return false
        }

        let index = isCameraCompatible ? indexPath.row - 1 : indexPath.row
        return delegate?.photoGalleryViewController(self, shouldTogglePhoto: fetchResult[index]) ?? false
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return shouldToggleTaggedItem(at: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldToggleTaggedItem(at: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggle(itemAt: indexPath, in: collectionView)
    }

    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        toggle(itemAt: indexPath, in: collectionView)
    }

    private func toggle(itemAt indexPath: IndexPath, in collectionView: UICollectionView) {
        let index = isCameraCompatible ? indexPath.row - 1 : indexPath.row
        delegate?.photoGalleryViewController(self, didTogglePhoto: fetchResult[index])

        var indexPaths = Set(collectionView.indexPathsForSelectedItems ?? [])
        indexPaths.insert(indexPath)
        collectionView.reloadItems(at: Array(indexPaths))
    }

    // MARK: - PHPhotoLibraryChangeObserver

    internal func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changeDetails = changeInstance.changeDetails(for: fetchResult) else {
            return
        }

        DispatchQueue.main.async {
            // Ask the delegate to handle the tagged assets that are removed from the photo library.
            changeDetails.removedObjects.filter {
                self.delegate?.photoGalleryViewController(self, taggedTextForPhoto: $0) != nil
            } .forEach {
                self.delegate?.photoGalleryViewController(self, didTogglePhoto: $0)
            }
            self.fetchResult = changeDetails.fetchResultAfterChanges
            self.collectionView.reloadData()
            self.showEmptyViewIfNeeded()
        }
    }

    // MARK: - Private

    private func photoGalleryLayout(for size: CGSize) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let estimatedWidth: CGFloat = 105
        let numberOfColumns = max(1, floor(size.width / estimatedWidth))
        let itemWidth = (size.width - layout.minimumInteritemSpacing * numberOfColumns - 1) / numberOfColumns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return layout
    }

    private func setUpSubviews() {
        view.backgroundColor = UIColor.white
        view.addSubview(hintLabel)
        view.addSubview(collectionView)

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hintLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func showEmptyViewIfNeeded() {
        if isCameraCompatible && fetchResult.count == 0 {
            if collectionView.frame == .zero {
                view.layoutIfNeeded()
            }
            view.addSubview(emptyView)
            emptyView.frame = collectionView.frame
            emptyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
            _emptyView?.removeFromSuperview()
        }
    }

    @objc private func launchCamera(withTapGesture recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: emptyView)
        let centerRect = CGRect(
            x: emptyView.bounds.midX - 75,
            y: emptyView.bounds.midY - 75,
            width: 150,
            height: 150
        )
        if centerRect.contains(location) {
            delegate?.photoGalleryViewControllerDidSelectCameraButton(self)
        }
    }
}


private extension PHAssetCollection {

    var isCameraCompatible: Bool {
        return
            UIImagePickerController.isSourceTypeAvailable(.camera) &&
            assetCollectionType == .smartAlbum &&
            assetCollectionSubtype == .smartAlbumUserLibrary
    }

}


private extension NSAttributedString {

    var attributes: [NSAttributedString.Key: Any]? {
        if 0 < length {
            return attributes(at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: length))
        } else {
            return nil
        }
    }

}
