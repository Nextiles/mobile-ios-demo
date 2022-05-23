# mobile-ios-demo
This repository is meant to demostrate how to use the NextilesSDK. It provides sample code to show you how to use the main functionality of the SDK. 

## Who this repository is meant for
This repository is meant for our clients who are planning to integrate the NextilesSDK into their application.

## Getting started
1. To get started please clone this repository. 
2. After successfully cloning, add the NX-info.plist file to the project hierarchy.
3. Lastly in the `DemoViewModel` file on line 21 when the SDK is being initialized, replace the organization parameter with your organization name.

```swift
//Example
//Initialize the SDK with your organization
    var sdk = NextilesSDK(organization: "Nextiles") { success in
        if success {
            print("SDK ready to use!")
        }
        else {
            print("SDK not initiliazed, functions will not work")
        }
    }
 ```
 ## How to use
 - When running the application you will be displayed a list of buttons that, when tapped on will perform different functions.
 - The compiler on the bottom of the app will let you know whether or not the function worked correctly.
   - If a function did not work it will detail ways to resolve the issue. 
 - Please note you cannot run Bluetooth functionality on a simulator, you must use an actual device.
 - All SDK functionality will can be found in the `DemoViewModel` file.

## Demo
https://user-images.githubusercontent.com/19720373/169857831-1e06f9b6-185b-4d62-bd5c-688d1a40c7fd.mp4


