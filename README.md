# BinaryDataLoader
Simple binary data loader for iOS
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Example
========
```swift
let loader = BinaryDataLoader()

loader.get(from: url) { (image: UIImage?) in
    completion(image)
}
```

The callback is generic, so the parameter can be any type which implements the `BinaryLoadable` protocol. `UIImage` and `NSData` implements it by default.

#Installation
## Carthage 

Put this line into your cartfile
```
github "Gujci/BinaryDataLoader"
```
