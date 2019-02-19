# SubscriberManagement
Sample app to manage subscribers with basic CRUD functions.

This project has been started with **Xcode 10**, written in [**Swift 4.2**](https://swift.org/blog/swift-4-2-released/) and uses [**Firebase**](https://firebase.google.com/) as Backend.

iOS version target: **11.0**

There's some frameworks included using [**Cocoapods**](https://cocoapods.org/), such us *(to get more info open the file **Podfile**)*:
- **Firebase/Core**: *Firebase core framework needed to use Firestore*
- **Firebase/Firestore**: *Firestore framework to use Firebase as DB*
- [**MBProgressHUD**](https://github.com/jdg/MBProgressHUD): *framework that shows a progress HUD for loading states*
- [**R.swift**](https://github.com/mac-cain13/R.swift): *helper to use resources (colors, strings, files, etc)*
- [**SCLAlertView**](https://github.com/vikmeup/SCLAlertView-Swift): *framework to show customized alerts*
- [**TinyConstraints**](https://github.com/roberthein/TinyConstraints): *helper to use Constraints with Autolayout*

## Additional tools

### **R.swift**
Add a **Build Phase** *Run Script* with this content:
```
"$PODS_ROOT/R.swift/rswift" generate "$SRCROOT/Digipal/Resources/R.generated.swift"
```

## How to compile
This project uses **Cocoapods**, to compile it first we need to install the dependencies using `pod install` before building.