import 'package:flutter/material.dart';
import 'screens/scan_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(new MyApp());

class GlobalData {
  static String auth;
  //static String url = 'http://localhost:8000/item'; //iOS TESTING
  static String url = 'http://10.0.2.2:8000/item'; //ANDROID TESTING
  //static String url ='https://17dfcfcc-63d3-456a-a5d8-c5f394434f7c.mock.pstmn.io';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry Application',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.deepPurple,
        cursorColor: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the LoginScreen widget.
        '/': (context) => LoginScreen(),
        // When navigating to the "/home" route, build the HomeScreen widget.
        '/home': (context) => HomeScreen(),
        // When navigating to the "/login" route, build the LoginScreen widget.
        '/login': (context) => LoginScreen(),
        // When navigating to the "/add" route, build the Scan widget.
        '/add': (context) => Scan(),
        // When navigating to the "/search" route, build the SearchScreen widget.
        //'/search' : (context) => SearchScreen()
      },
    );
  }
}

/**
 * https://ionicframework.com/docs/v3/developer-resources/platform-setup/mac-setup.html
 *
 * Change your /android/build.gradle variable: ext.kotlin_version = '1.2.31' to '1.3.61'
 *
 * Change your /android/app/build.gradle variable: targetSdkVersion 29 and buildToolsVersion = '29.0.2'
 *
 * Change your /android/build.gradle variable: classpath 'com.android.tools.build:gradle:3.4.2'
 *
 * Under /android/gradlew.bat click on plugin for mac OS
 *
 * GitHub Build
 */
