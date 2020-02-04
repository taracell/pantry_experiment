# pantry

A new Flutter application for CMSC 495 Spring 2020 Group 6.

## Getting Started

This project is a starting point for a Flutter Pantry Mobile Application.

This branch has all of the created flutter files for the UI portion of the project.

## Downloaded Items: 
	Flutter
	Android Studio
	Xcode

Research how to use Flutter and program application:

### home_screen.dart:  
Flutter packages added:
Flutter specifics: uses-material-design 

https://blog.brainsandbeards.com/bottom-navigation-with-a-list-screen-in-flutter-d517dc6f22f1
Much of the beginning of the project programming came from this article

@ Files produced as a result: main.dart, home_screen.dart, pantry_list.dart
@ Files edited as a result:  pubspec.yaml (added dependencies)

### login_screen.dart:  
Flutter packages added: flutter_login

https://pub.dev/packages/flutter_login
Followed documentation from link altering it.

@ Files produced as a result: login_screen.dart, users.dart (to be utilized better without constant when API is available), fade_route.dart
@ Files edited as a result:  pubspec.yaml (updates in comments on file), main.dart (added routes)

### camera.dart:
Flutter packages added: camera

https://blog.brainsandbeards.com/how-to-add-camera-support-to-a-flutter-app-c1dfd6b78823
https://pub.dev/packages/camera
All of the programming came from this site for the camera...I had a hard time getting the camera to work at first, but after reloading flutter and ensuring all dependencies were set correctly, it started working.  I blew all programs and files away and used back-up files from GitHub to recreate.  

Found that the text wasn't quite inputting correctly, upon more research I found that the text input controllers were not input correctly.  This led to a revamp of how the controllers were input into the widget and showed state.  This allows for future use to be able to put into JSON as well as a get from JSON and editable once received.

@ Files produced as a result:  camera.dart
@ Files edited as a result:  pubspec.yaml (updates in comments on file), home_screen.dart (added CameraWidget()), android/app/build.gradle (updates in comments on file), android/build.gradle(update kotlin version, and both classpath dependencies), ios/runner/info.plist (updates in comments on file)

### Found issue was not building iOS at all:

Terminal commands:
cd /Users/tara/AndroidStudio/pantry/ios <<<Your Path to your project ios file>>>
pod install

If you get the following error:
[!] CocoaPods did not set the base configuration of your project because your project already has a custom config set. In order for CocoaPods integration to work at all, please either set the base configurations of the target `Runner` to `Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig` or include the `Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig` in your build configuration (`Flutter/Release.xcconfig`).

Add command to file in project:  ios/Flutter/Release.xcconfig: 
#include "Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"

Found issue not building in Android:

Place the following commands in project folder without the quotes:  /pantry/android/app/src/profile/AndroidManifest.xml

"<activity android:name="com.apptreesoftware.barcodescan.BarcodeScannerActivity"/>"
"<uses-permission android:name="android.permission.CAMERA" />"

### Pantry_list.dart:
Flutter packages added: http, json_annotation, build_runner, json_serializable

Found a fake back end, to simulate database input with JSON:  jsonplaceholder.typicode.com/
My link is:  https://my-json-server.typicode.com/taracell/
This is not working...I have to find something else.

Cleared up parsing from simple Json using postman, as suggested by Tony...my postman link is:  'https://2c0fb3de-8d5e-4930-aed7-35d266bb88b7.mock.pstmn.io'

Using:  https://medium.com/@diegoveloper/flutter-fetching-parsing-json-data-c019ddddaa34
https://bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/#DartFlutter_parse_JSON_string_into_Object

#Note! The files produced from the build_runner are listed as file_name.g.dart...this produces the boilerplate for toJson and fromJson for your built classes.  This ensures your stuff works and makes the program work better than attempts from other websites.

@ Files produced as a result:  pantry_list.dart, pantry_list.g.dart
@ Files edited as a result:  pubspec.yaml (updates in comments on file), android/app/build.gradle (updates in comments on file)

### scan_screen.dart: 
Flutter packages added: barcode_scan_fix: ^1.0.2 and barcode_scan, intl

#Note! The barcode API is free and is acquired by using the following link within the application: 'https://api.upcitemdb.com/prod/trial/lookup?upc=' + barcode)’  the barcode is scanned by the application and stored in a string variable for use within the get http command

To see a typical JSON output go to:  https://www.upcitemdb.com/api/explorer#!/lookup/get_trial_lookup and input the following UPC:  0024000162865

#Note! The JSON output is complex and advanced for my knowledge, so I’m researching how to get the title from the standard output from the UPC scanned within the application.

Used for advanced JSON parsing...Looking for how to parse more complex JSON in flutter!
https://www.youtube.com/watch?v=NnY4B7VK6e4.  

Interesting find today...makes my dart classes for me from the raw json input, need to alter a lot to create factories for use but the base classes are there for use:  https://javiercbk.github.io/json_to_dart/

#Note! Found that JSON does not have a DateTime object it only possesses strings for this.  To make the parsing easier, created a formatter in main.dart to parse all DateTime to strings in MM/dd/yyyy format this should make things easier once the API is created and usable for all DateTime objects 

@ Files produced as a result:  scan_screen.dart, upc_base_response.dart, upc_base_response.g.dart
@ Files edited as a result:  application/android build.gradle, and pubspec.yaml, main.dart

### search_screen.dart: 
Flutter packages added: 

Files produced as a result:  search_screen.dart, 
Files edited as a result:  

