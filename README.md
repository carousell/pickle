# Pickle

[![Build Status](https://travis-ci.org/carousell/pickle.svg)](https://travis-ci.org/carousell/pickle)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Pickle.svg)](https://cocoapods.org/pods/Pickle)
![Platform](https://img.shields.io/cocoapods/p/Pickle.svg)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)

Carousell image picker.

* Multiple image selections across albums
* Picking photos in the desired order
* Customizable theme

<img src="https://carousell.github.io/pickle/img/screenshot.png" width="50%" />

## Usage

```swift
import Pickle
```

The usage is similiar to `UIImagePickerController`:

```swift
let picker = ImagePickerController()
picker.delegate = self as? ImagePickerControllerDelegate
present(picker, animated: true, completion: nil)
```

Display preselected images:

```swift
let assets: [PHAsset] = []
let picker = ImagePickerController(selectedAssets: assets)
```

`ImagePickerController` will request permission to access **Photos** if needed when it's presented.

### Delegate

`ImagePickerControllerDelegate` is responsible for dismissing the image picker. Required delegate methods:

```swift
/// Asks the delegate if the image picker should launch camera with certain permission status.
func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool

/// Tells the delegate that the user picked image assets. The delegate is responsible for dismissing the image picker.
func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset])

/// Tells the delegate that the user cancelled the pick operation. The delegate is responsible for dismissing the image picker.
func imagePickerControllerDidCancel(_ picker: ImagePickerController)
```

### Appearance

Customize the appearance with a modified `Parameters` struct, or any type that conforms to `ImagePickerConfigurable`.

```swift
var parameters = Pickle.Parameters()
parameters.allowedSelections = .limit(to: 4)
let picker = ImagePickerController(configuration: parameters)
```

See [ImagePickerConfigurable.swift](https://github.com/carousell/pickle/blob/master/Pickle/Classes/ImagePickerConfigurable.swift) for a full list of configurable properties.

### Camera

`UIImagePickerController` with `sourceType = .camera` is used as the default camera on devices. Launch a customized camera from the image gallery by providing a [`CameraCompatible`](https://github.com/carousell/pickle/blob/master/Pickle/Classes/CameraCompatible.swift) type or a closure that returns a configured camera controller instance.

```swift
let picker = ImagePickerController(
  selectedAssets: [],
  configuration: Pickle.Parameters(),
  cameraType: UIImagePickerController.self
)
```

```swift
let initializer = {
  return UIImagePickerController()
}

let picker = ImagePickerController(
  selectedAssets: [],
  configuration: Pickle.Parameters(),
  camera: initializer
)
```

## Documentation

### Pickle Reference

<https://carousell.github.io/pickle>

### Example Setups

Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation):

```
gem install cocoapods
```

Set up the development pods:

```sh
make bootstrap
```

## Requirements

Pickle     | iOS  | Xcode | Swift
---------- | :--: | :---- | :---:
`>= 1.0.0` | 8.0+ | 8.3.3 | ![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)
`>= 1.2.0` | 9.0+ | 8.3.3 | ![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)
`>= 1.3.0` | 9.0+ | 9.2   | ![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)

## Installation

### Use [CocoaPods](http://guides.cocoapods.org/)

Create a `Podfile` with the following specification and run `pod install`.

```rb
platform :ios, '9.0'
use_frameworks!

pod 'Pickle'
```

### Use [Carthage](https://github.com/Carthage/Carthage)

Create a `Cartfile` with the following specification and run `carthage bootstrap`.
Follow the [instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the framework to your project.

```
github "carousell/pickle"
```

## Contributing

Thank you for being interested in contributing to this project. Check out the [CONTRIBUTING](https://github.com/carousell/pickle/blob/master/CONTRIBUTING.md) document for more info.

## About

<a href="https://github.com/carousell/" target="_blank"><img src="https://avatars2.githubusercontent.com/u/3833591" width="100px" alt="Carousell" align="right"/></a>

**Pickle** is created and maintained by [Carousell](https://carousell.com/). Help us improve this project! We'd love the [feedback](https://github.com/carousell/pickle/issues) from you.

We're hiring! Find out more at <http://careers.carousell.com/>

## License

**Pickle** is released under Apache License 2.0.
See [LICENSE](https://github.com/carousell/pickle/blob/master/LICENSE) for more details.
