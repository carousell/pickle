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
import Pickle
import Photos

final class ViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    ImagePickerControllerDelegate {

    private enum Section: Int {
        case `default`
        case customized

        static var count: Int {
            var count = 0
            while let _ = Section(rawValue: count) { count += 1 }
            return count
        }

        var title: String {
            switch self {
            case .default:      return "Default appearance"
            case .customized:   return "Customized appearance"
            }
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pickle"
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = Section(rawValue: indexPath.section)?.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picker: ImagePickerController
        switch Section(rawValue: indexPath.section) {
        case .some(.customized):
            picker = CarousellImagePickerController()
        default:
            picker = ImagePickerController()
        }
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    // MARK: - ImagePickerControllerDelegate

    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }

    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        debugPrint(assets)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerRequiresPhotoLibraryPermission(_ picker: ImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
