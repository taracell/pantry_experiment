import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

void main() => runApp(new MyApp());

String getDate() {
  var today = new DateTime.now();
  var formatter = new DateFormat('MM/dd/yyyy');
  String formattedDate = formatter.format(today);
  return formattedDate;
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
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LoginScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => HomeScreen(),
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
