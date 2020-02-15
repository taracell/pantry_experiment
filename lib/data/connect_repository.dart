import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pantry/screens/home_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';
import '../models/inventory.dart';
import '../models/upc_base_response.dart';
import '../screens/scan_screen.dart';
import '../utils/fade_route.dart';

Future<List<Inventory>> fetchInventory(
    http.Client client, BuildContext context) async {
  final response = await http.get(GlobalData.url, headers: {
    "Content-Type": "application/json",
    //"Accept": "application/json",
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
      //unit: "${unitController.text}",
      //quantity: int.parse("${quantityController.text}"),
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
    _alertFail(
        context, 'Item not added, please check your input and try again');
    throw Exception('Failed to load to Inventory');
    // If that call was not successful, throw an error.
  }
}

Future<dynamic> fetchBarcodeInfo(http.Client client, String barcode) async {
  final response = await http
      .get('https://api.upcitemdb.com/prod/trial/lookup?upc=' + barcode);
  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    var baseResponse = BaseResponse.fromJson(responseBody);
    return baseResponse;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load item');
  }
}

void _alertSuccess(context, String message) {
  new Alert(
    context: context,
    type: AlertType.info,
    title: "Success",
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
}

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
}
