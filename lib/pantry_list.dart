import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
part 'pantry_list.g.dart';

Future<List<Inventory>> fetchInventory(http.Client client) async {
  final response = await http
  .get('https://2c0fb3de-8d5e-4930-aed7-35d266bb88b7.mock.pstmn.io');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return compute(parseItems, response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load pantry items');
  }
}

List<Inventory> parseItems(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Inventory>((json) => Inventory.fromJson(json)).toList();
}

@JsonSerializable()
class Inventory {
  final int quantity;
  final String title;
  final String acquisition;
  final String expiration;

  Inventory({this.title, this.acquisition, this.quantity, this.expiration});

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
        quantity: json['quantity'] as int,
        title: json['title'] as String,
        acquisition: json['acquisition'] as String,
        expiration: json['expiration'] as String);
  } //factory
} //Inventory

class PantryList extends StatefulWidget {
  PantryList({Key key}) : super(key: key);
  @override
  PantryListState createState() => PantryListState();
}

class PantryListState extends State<PantryList> {
  Future<Inventory> inventory;
  var isLoading = false;
  //List<GridTile> _inventory = <GridTile>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(
          child: CircularProgressIndicator(),
          )
            : FutureBuilder<List<Inventory>>(
              future: fetchInventory(http.Client()),
              builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return snapshot.hasData
                ? InventoryList(inventory: snapshot.data)
                  : Center(child: CircularProgressIndicator());
              }
            ));
  }
}

class InventoryList extends StatelessWidget {
  final List<Inventory> inventory;

  InventoryList({Key key, this.inventory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: key,
      itemCount: inventory.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: const EdgeInsets.all(4),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return _buildCard(context, index);
      }
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    return Center(
      child: Card(
        color: new Color(0xFF11AA33),
        child: SizedBox(
          width: 200,
          height: 100,
          //margin: new EdgeInsets.all(1),
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Text(inventory[index].title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              Text('Quantity: ' + inventory[index].quantity.toString()),
              Text('Acquisition: ' + inventory[index].acquisition),
              Text('Expiration: ' + inventory[index].expiration),
            ]
          )
        )
      )
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
