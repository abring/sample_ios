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
