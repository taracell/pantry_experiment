import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../models/inventory.dart';
import '../models/upc_base_response.dart';
import '../screens/home_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/login_screen.dart';
import '../utils/fade_route.dart';
import 'local_repository.dart';

Future<String> login(loginData, BuildContext context) async {
  GlobalData.auth = 'Basic ' +
      base64Encode(utf8.encode("${loginData.name}:${(loginData.password)}"));
  print(GlobalData.auth);
  var response;
  try {
    await Future<void>.delayed(Duration(seconds: 1));
    response = await http.get(GlobalData.url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": GlobalData.auth,
    }).timeout(Duration(seconds: 2));
  } on TimeoutException catch (e) {
    _alertFailLogin(context, 'Failed to login to server. ' + e.toString());
  } finally {
    GlobalData.client.close();
  }

  if (response.statusCode == 200) {
    return null;
  } else {
    print("Not Logged In to server");
    print(response.body);
    _alertFailLogin(context,
        'Failed to login to server. ' + response.statusCode.toString());
    throw Exception('Failed to load to Server Inventory');
  }
} //login

Future<List<Inventory>> fetchInventory(BuildContext context) async {
  final response = await http.get(GlobalData.url, headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": GlobalData.auth,
  }); //response

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return compute(parseItems, response.body);
  } else {
    // If that call was not successful, throw an error.
    _alertFail(
        context, 'Did not connect to server ' + response.statusCode.toString());
    throw Exception('Failed to load pantry items');
  }
}

List<Inventory> parseItems(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Inventory>((json) => Inventory.fromJson(json)).toList();
}

Future addToInventory(context) async {
  Inventory inventory = new Inventory(
      name: "${Connections.itemController.text}",
      acquisition: Connections.acquisition.substring(0, 10),
      //unitType: "${Connections.unitController.text}",
      expiration: Connections.expiration.substring(0, 10));

  var responseBody = json.encode(inventory);
  final response = await http.post(GlobalData.url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": GlobalData.auth
      },
      body: responseBody);
  if (response.statusCode == 200) {
    print(response.body);
    print(responseBody);
    _alertSuccess(context, 'Item sucessfully added to inventory');
    return response;
  } else {
    writeItem(responseBody);
    _alertFail(context, 'Item not added to server');
    throw Exception('Failed to load to server Inventory');
  }
} //addToInventory

Future<dynamic> fetchBarcodeInfo(http.Client client, String barcode) async {
  final response = await http
      .get('https://api.upcitemdb.com/prod/trial/lookup?upc=' + barcode);
  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    var baseResponse = BaseResponse.fromJson(responseBody);
    return baseResponse;
  } else {
    throw Exception('Failed to load item from website');
  }
} //fetchBarcodeInfo

void _alertSuccess(context, String message) {
  new Alert(
    context: context,
    type: AlertType.info,
    title: "CONGRATS",
    desc: message,
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
} //_alertSuccess

void _alertFail(context, String message) {
  new Alert(
    context: context,
    type: AlertType.error,
    title: "ERROR",
    desc: message,
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
} //_alertFail

void _alertFailLogin(context, String message) {
  new Alert(
    context: context,
    type: AlertType.error,
    title: "ERROR",
    desc: message,
    buttons: [
      DialogButton(
          child: Text(
            "Try Again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.teal,
          onPressed: () => Navigator.of(context).pushReplacement(
              FadePageRoute(builder: (context) => LoginScreen()))),
      DialogButton(
        child: Text(
          "Work Offline",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => _workOffline(context),
      ),
    ],
  ).show();
} //_alertFailLogin

void _workOffline(context) {
  GlobalData.offline = true;
  Navigator.of(context)
      .pushReplacement(FadePageRoute(builder: (context) => HomeScreen()));
}
