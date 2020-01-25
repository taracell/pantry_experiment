import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> fetchItems(http.Client client) async {
  final response =
      await http.get('https://my-json-server.typicode.com/taracell/json_demo');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return compute(parseItems, response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load pantry items');
  }
}

List<Item> parseItems(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Item>((json) => Item.fromJson(json)).toList();
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<List<Item>>(
                future: fetchItems(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return snapshot.hasData
                      ? ItemList(items: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                }));
  }
}

class ItemList extends StatelessWidget {
  final List<Item> items;

  ItemList({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Image.network(items[index].item);
      },
    );
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
