# SubscriberManagement
Sample app to manage subscribers with basic CRUD functions.
This project has been started with **Xcode 10**, written in **Swift 4.2**.

iOS version target: **11.0**

There's some frameworks included using **Cocoapods**, such us *(to get more info open the file **Podfile**)*:
- **Firebase/Core**: *Firebase core framework needed to use Firestore*
- **Firebase/Core**: *Firestore framework to use Firebase as DB*
- **R.swift**: *helper to use resources (colors, strings, files, etc)*
- **TinyConstraints**: *helper to use Constraints with Autolayout*

## Additional tools

### **R.swift**
Add a **Build Phase** *Run Script* with this content:
```
"$PODS_ROOT/R.swift/rswift" generate "$SRCROOT/Digipal/Resources/R.generated.swift"
```

## How to compile
This project uses **Cocoapods**, to compile it first we need to install the dependencies using `pod install` before building.