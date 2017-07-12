# BinaryDataLoader
Simple binary data loader for iOS

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/Gujci/BinaryDataLoader.svg?branch=master)](https://travis-ci.org/Gujci/BinaryDataLoader)

# Example

```swift
let loader = BinaryDataLoader()

loader.get(from: url) { (image: UIImage?) in
    completion(image)
}
```

The callback is generic, so the parameter can be any type which implements the `BinaryLoadable` protocol. `UIImage` and `NSData` implements it by default.

## Cache

The framework caches data to the documents directory if needed. The `CachePolicy` can be set at each loading. By default it uses the `.newest`.

# Installation
## Carthage 

Put this line into your cartfile
```
github "Gujci/BinaryDataLoader"
```

## TODO

#### 0.1
 - [ ] Full code coverage for tests
 - [x] Travis
 - [ ] General cache policy
 - [ ] Data upload
