<p align="center">
  <img src="http://static.photoeditorsdk.com/logo.png" />
</p>

# PhotoEditor SDK React Native Demo
This project shows how to easily integrate the [PhotoEditor SDK](https://www.photoeditorsdk.com/?utm_campaign=Projects&utm_source=Github&utm_medium=Side_Projects&utm_content=React-Native-Demo) into a React Native application. 

**THIS IS A DEMO**. This repository is not meant as a fully fledged React Native plugin, but as a base for further development instead. For more details, check the [accompanying blog post](https://blog.photoeditorsdk.com/photoeditor-sdk-react-native-15179c589a55#.s6c81ua7w).

## Example App
The included example app demonstrates how to open the PhotoEditor SDK's editor with an image that has previously been downloaded using React Native. Upon closing the editor, the edited image is returned to React Native and may be processed further, presented ot the user etc. This demo simply shows an alert to give you a hint on how to move on.

Use React Natives `react-native run-ios` and `run-android` to launch the emulators.

## Note
The PhotoEditor SDK is a product of 9elements GmbH. 
To use the PhotoEditor SDK within your app **you'll need to load a license file**:

```swift
// iOS
PESDK.unlockWithLicense(at: licenseURL)
```

```java
// Android
PESDK.init(this, "LICENSE_FILENAME")
```

You'll need to [order a license](https://www.photoeditorsdk.com/pricing#contact/?utm_campaign=Projects&utm_source=Github&utm_medium=Side_Projects&utm_content=React-Native-Demo) and refer to [our documentation](https://docs.photoeditorsdk.com?utm_campaign=Projects&utm_source=Github&utm_medium=Side_Projects&utm_content=React-Native-Demo) for more details. Please see `LICENSE.md` for licensing details.

As the Android SDK links different modules depending on your configuration, we're providing a Gradle plugin which needs to be added to your Android project. To prepare this, you'll have to add the following lines to your projects .gradle file (`android/build.gradle`):

 ```
 buildscript {
     repositories {
         // ...
         maven { url "https://artifactory.9elements.com/artifactory/imgly" }
     }
     dependencies {
         // ...
         classpath 'ly.img.android.pesdk:plugin:6.0.0'
     }
 }

 allprojects {
     repositories {
         // ...
         maven { url "https://artifactory.9elements.com/artifactory/imgly" }
     }
     // ...
 }
 ```

## PhotoEditor SDK for iOS & Android
The [PhotoEditor SDK](https://www.photoeditorsdk.com/?utm_campaign=Projects&utm_source=Github&utm_medium=Side_Projects&utm_content=React-Native-Demo) for iOS and Android are **fully customizable** photo editors which you can integrate into your React Native app within minutes.

## License
Please see [LICENSE](https://github.com/imgly/pesdk-react-native-demo/blob/master/LICENSE.md) for licensing details.

## Authors and Contributors
Made 2013-2017 by @9elements

## Support or Contact
Contact contact@photoeditorsdk.com for support requests or to upgrade to an enterprise licence.


