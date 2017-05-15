# Pickle

[![Build Status](https://travis-ci.org/carousell/pickle.svg)](https://travis-ci.org/carousell/pickle)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Pickle.svg)](https://cocoapods.org/pods/Pickle)
![Platform](https://img.shields.io/cocoapods/p/Pickle.svg)
[![CocoaDocs](https://img.shields.io/cocoapods/metrics/doc-percent/Pickle.svg)](https://carousell.github.io/pickle)
![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)

Carousell image picker.

* Multiple image selections
* Customizable theme

<img src="https://carousell.github.io/pickle/img/screenshot.png" width="50%"></img>

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

## Customization

### Appearance

Customize the appearance with a type that conforms to `ImagePickerConfigurable`.

```swift
let configuration: ImagePickerConfigurable = CustomizedType()
let picker = ImagePickerController(configuration: configuration)
```

See [ImagePickerConfigurable.swift](https://github.com/carousell/pickle/blob/master/Pickle/Classes/ImagePickerConfigurable.swift) for a full list of configurable properties.

### Camera

`UIImagePickerController` with `sourceType = .camera` is used as the default camera on devices. Launch a customized camera from the image gallery by providing a [`CameraCompatible`](https://github.com/carousell/pickle/blob/master/Pickle/Classes/CameraCompatible.swift) type or a closure that returns a configured camera controller instance.

```swift
let picker = ImagePickerController(
  selectedAssets: [],
  configuration: CustomizedType(),
  cameraType: UIImagePickerController.self
)
```

```swift
let initializer = {
  return UIImagePickerController()
}

let picker = ImagePickerController(
  selectedAssets: [],
  configuration: CustomizedType(),
  camera: initializer
)
```

## Requirements

Pickle     | iOS  | Xcode | Swift
---------- | :--: | :---: | :---:
`~> 1.0.0` | 8.0+ | 8.3.2 | ![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)

## Installation

### Use [CocoaPods](http://guides.cocoapods.org/)

Create a `Podfile` with the following specification and run `pod install`.

```rb
platform :ios, '8.0'
use_frameworks!

pod 'Pickle', '~> 1.0.0'
```

### Use [Carthage](https://github.com/Carthage/Carthage)

Create a `Cartfile` with the following specification and run `carthage bootstrap`.
Follow the [instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the framework to your project.

```
github "carousell/pickle" ~> 1.0.0
```

## Development

Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation):

```
gem install cocoapods
```

Set up the development pods:

```shell
pod install --project-directory=Example && open Example/Pickle.xcworkspace
```

## Contact

<http://contact.carousell.com/>

## License

**Pickle** is released under Apache License 2.0.
See [LICENSE](https://github.com/carousell/pickle/blob/master/LICENSE) for more details.
