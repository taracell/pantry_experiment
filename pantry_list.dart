import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Item> fetchPost() async {
  final response =
      await http.get('https://my-json-server.typicode.com/taracell/json_demo');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Item.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load pantry items');
  }
}

class Item {
  final int quantity;
  final String item;
  final String manufacture;
  final DateTime expiration;

  Item({this.item, this.manufacture, this.quantity, this.expiration});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        item: json['item'],
        manufacture: json['manufacture'],
        quantity: json['quantity'],
        expiration: json['expiration']);
  } //factory
} //Item

class PantryList extends StatefulWidget {
  PantryList({Key key}) : super(key: key);
  @override
  PantryListState createState() => PantryListState();
}

class PantryListState extends State<PantryList> {
  Future<Item> item;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    item = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pantry List"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<Item>(
                future: item,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.item);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                }));
  }
}

/**
 *  in pubspec.yaml:
    dependencies:
    flutter:
      sdk: flutter
    http: ^0.12.0
    json_annotation: ^2.0.0

    dev_dependencies:
    flutter_test:
      sdk: flutter
    build_runner: ^1.0.0
    json_serializable: ^2.0.0
 */
