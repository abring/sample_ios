[![License](https://img.shields.io/cocoapods/l/TransitionButton.svg?style=flat)](https://github.com/abring/sample_ios)
[![Platform](https://img.shields.io/cocoapods/p/TransitionButton.svg?style=flat)](https://github.com/abring/sample_ios)

## Preview
<img src="http://s9.picofile.com/file/8301979300/abring_ios.jpg" height="527">

## About
Abring makes it easy to implement login to your app.

## There are 3 ways you can use Abring
- Ignore this library and use HTTP APIs
- Using it by just SDK APIs (UI is by your own)
- Let SDK handle the UI for you 

## Requirements
- iOS 10.0+
- XCode 8.0
- Swift 3


## Integration
#### CocoaPods
You can use CocoaPods to install `Abring` by adding it to your Podfile:
```
platform :ios, '10.0'
use_frameworks!

target 'MyApp' do
	pod 'Abring'
end
```

## Usage
```swift
import Abring
```

Config the UI in the `Appdelegate.swift` file
```swift
ABAppConfig.name = "your App Id"
ABAppConfig.font = //Customized Font
ABAppConfig.tintColor //Your app tint color
...
```

and finally add this line of code to present login
```swift
presentLogin(style: .LightBlurBackground, delegate: self)
```

Don't forget to implement delegate methods
```swift
func userDismissScreen()
func userDidLogin(_ player: ABPlayer)
```

## License
`Abring` is available under the MIT license. See the LICENSE file for more info.
