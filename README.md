[![pod](https://img.shields.io/badge/pod-v0.3.0-blue.svg)](https://github.com/abring/sample_ios)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://github.com/abring/sample_ios)
[![language](https://img.shields.io/badge/language-swift-orange.svg)](https://github.com/abring/sample_ios)
[![License](https://img.shields.io/cocoapods/l/TransitionButton.svg?style=flat)](https://github.com/abring/sample_ios)



## Preview
<img src="http://s6.uplod.ir/i/00891/9disyu31zafh.jpg" height="527">

## About
Abring makes it easy to implement login to your app.

## Requirements
- iOS 10.0+
- XCode 8.0
- Swift 4


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
Go to Abring.ir website and add an app in your panel.
You must set project name in ABAppConfig later in your project.

Type these to the `Appdelegate.swift` file:
```swift
import Abring
```
```swift
ABAppConfig.name = "your App Id"
```

The login viewcontroller is highly customizable:
```swift
ABAppConfig.font = UIFont.systemFont(ofSize: 14) //or your own font
ABAppConfig.tintColor = UIColor.cyan
ABAppConfig.labelsColor = UIColor.gray
ABAppConfig.mainButton = UIButton() // your custom UIButton
ABAppConfig.texts.inputPhoneText = "input phone title"
ABAppConfig.texts.inputCodeText = "input code title"
ABAppConfig.buttonsTitles.loginSendCodeToPhoneButtonTitle = "Send Code"
ABAppConfig.buttonsTitles.loginConfirmCodeButtonTitle = "Done"

// you can customize textfields and their placeholders too.
```

and finally add this line of code in your viewcontroller to present login
```swift
presentLogin(style: .lightBlurBackground, delegate: self)
```

Don't forget to implement `AbLoginDelegate` methods:

```swift
func userDismissScreen()
func userDidLogin(_ player: ABPlayer)
```

## Still want more flexability?
You can ignore our UI and implement your own UI.
Just use these methods when you need them:
```swift
ABPlayer.requestRegisterCode(phoneNumber: String, completion: LoginCompletionBlock) {}
ABPlayer.verifyRegisterCode(phoneNumber: String, code: String, completion: @escaping (_ success: Bool, _ player: ABPlayer?, _ errorType: ABErrorType?)
```

## License
`Abring` is available under the MIT license. See the LICENSE file for more info.
