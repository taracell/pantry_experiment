import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart'; //make sure to look up this package before messing with this screen
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'fade_route.dart';
import 'home_screen.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  static const routeName = '/auth';
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 3000);
  String basicAuth;

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Pantry Login',
      messages: LoginMessages(
        usernameHint: 'Username',
        passwordHint: 'Pass',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot huh?',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Passwords do not match!',
        recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
        recoverPasswordDescription: 'Lorem Ipsum is simply dummy text '
            'of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password recovered successfully',
      ),
      //TODO - More robust form validation for login
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Your password must contain at least 8 characters.';
          // ignore: missing_return
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('E-mal: ${loginData.name}');
        print('Password: ${loginData.password}');
        return login(loginData, context);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('E-mail: ${loginData.name}');
        print('Password: ${loginData.password}');
        return login(loginData, context);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => HomeScreen(),
        ));
      },
      onRecoverPassword: (email) {
        print('Recover password info');
        print('E-mail: $email');
        return null;
        //Show new password dialog
      },
      showDebugButtons: false,
    );
  }

  Future<String> login(LoginData loginData, BuildContext context) async {
    var url = 'http://10.0.2.2:8000/item'; //ANDROID
    //var url = 'http://localhost:8000/admin/login/?next=/admin/auth/user'; //iOS
    setState(() => this.basicAuth = 'Basic ' +
        base64Encode(utf8.encode("${loginData.name}:${(loginData.password)}")));
    print(basicAuth);
    GlobalData.auth = basicAuth;
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        //"Accept": "application/json",
        "Authorization": basicAuth,
      },
    ); //body: responseBody
    print(response.toString());
    print(response.body.toString());
    if (response.statusCode == 200) {
      _alertSuccess(context);
      return response.toString();
    } else {
      print("Not Logged In");
      print(response.body);
      _alertFail(context, response.statusCode);
      throw Exception('Failed to load to Inventory');
      // If that call was not successful, throw an error.
    }
  }

  void _alertSuccess(context) {
    new Alert(
      context: context,
      type: AlertType.info,
      title: "Information",
      desc: "Login Success!.",
      buttons: [
        DialogButton(
          child: Text(
            "Transfer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.teal,
          onPressed: () => Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => HomeScreen(),
          )),
        ),
      ],
    ).show();
  }

  void _alertFail(context, response) {
    new Alert(
      context: context,
      type: AlertType.error,
      title: "ERROR",
      desc: "Something went wrong " + response.toString(),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.teal,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ).show();
  }
}
