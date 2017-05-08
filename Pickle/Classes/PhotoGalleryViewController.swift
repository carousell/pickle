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


internal class PhotoGalleryViewController: UIViewController,
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
            if let color = newValue?.attributes?[NSBackgroundColorAttributeName] as? UIColor {
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

    private let album: PHAssetCollection
    private let configuration: ImagePickerConfigurable?
    private(set) lazy var isCameraCompatible: Bool = self.album.isCameraCompatible

    private(set) lazy var fetchResult: PHFetchResult<PHAsset> = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        return PHAsset.fetchAssets(in: self.album, options: options)
    }()

    private lazy var hintLabel: UILabel = PhotoGalleryHintLabel()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: photoGalleryLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(PhotoGalleryCameraCell.self, forCellWithReuseIdentifier: String(describing: PhotoGalleryCameraCell.self))
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: String(describing: PhotoGalleryCell.self))
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    private class var photoGalleryLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let itemWidth = (UIScreen.main.bounds.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return layout
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }

    // MARK: - UICollectionViewDataSource

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCameraCompatible ? fetchResult.count + 1 : fetchResult.count
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCameraCompatible && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoGalleryCameraCell.self), for: indexPath)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoGalleryCell.self), for: indexPath)
        let index = isCameraCompatible ? indexPath.row - 1 : indexPath.row
        let asset = fetchResult[index]

        if let text = delegate?.photoGalleryViewController(self, taggedTextForPhoto: asset) {
            (cell as? PhotoGalleryCell)?.configure(with: asset, taggedText: text, configuration: configuration)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            (cell as? PhotoGalleryCell)?.configure(with: asset, configuration: configuration)
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
        }
    }

    // MARK: - Private

    private func setUpSubviews() {
        view.backgroundColor = UIColor.white
        view.addSubview(hintLabel)
        view.addSubview(collectionView)

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 9.0, *) {
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            hintLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

            collectionView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[hint]|",
                options: [],
                metrics: nil,
                views: ["hint": hintLabel]
            ))
            view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:[top][hint][gallery]|",
                options: [.alignAllLeading, .alignAllTrailing],
                metrics: nil,
                views: ["top": topLayoutGuide, "hint": hintLabel, "gallery": collectionView]
            ))
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

    var attributes: [String: Any]? {
        if 0 < length {
            return attributes(at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: length))
        } else {
            return nil
        }
    }

}
