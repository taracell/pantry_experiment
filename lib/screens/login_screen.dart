import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../data/connect_repository.dart';
import '../utils/fade_route.dart';
import '../main.dart';
import 'home_screen.dart';

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
}
