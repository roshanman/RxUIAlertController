# RxUIAlertController

[![CocoaPods](https://img.shields.io/cocoapods/v/RxUIAlertController.svg)](https://github.com/roshanman/RxUIAlertController)
![Swift 4](https://img.shields.io/badge/Swift-4.0.x-orange.svg)
[![License](https://img.shields.io/cocoapods/l/RxSwift-Permission.svg?style=flat)](http://cocoapods.org/pods/RxUIAlertControllerssion)
[![Platform](https://img.shields.io/cocoapods/p/RxSwift-Permission.svg?style=flat)](http://cocoapods.org/pods/RxUIAlertController)

RxUIAlertController is a wrapper library to work with RxSwift and UIAlertController.



## Installation

RxUIAlertController is available through [CocoaPods](http://cocoapods.org).


```ruby
pod 'RxUIAlertController'
```

### Sample code
```swift
Alert(title: "Test", message: "This is a test message.")
    .addAction(title: "Yes")
    .addAction(title: "No", style: .destructive)
    .addTextField{
        $0.placeholder = "placeholder"
    }
    .rx.show()
    .subscribe(onNext: {
        print("button: \($0.buttonTitle)")
        print($0.controller.textFields?.first?.text ?? "")
    })
    .addDisposableTo(disposeBag)

ActionSheet(title: "Test", message: "This is a test message.")
    .addAction(title: "Yes")
    .addAction(title: "No", style: .destructive)
    .addAction(title: "Cancel", style: .cancel)
    .setPresenting(source: sender)
    .rx.show()
    .subscribe(onNext: {
        print("button: \($0.buttonTitle)")
    })
    .addDisposableTo(disposeBag)

```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License

RxUIAlertController is available under the MIT license. See the LICENSE file for more info.
