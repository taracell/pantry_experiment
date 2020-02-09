import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
part 'pantry_list.g.dart';

//String url = 'https://14186d37-8753-4052-924a-c403f155a8bb.mock.pstmn.io';
String url = 'http://10.0.2.2:8000/item';

Future<List<Inventory>> fetchInventory(http.Client client) async {
  final response = await http.get(url);

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
  final String name;
  final String acquisition;
  //final int quantity;
  //final String unit;
  final String expiration;

  Inventory(
      {this.name,
      this.acquisition,
      //this.unit,
      //this.quantity,
      this.expiration});

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
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
                }));
  }
}

class InventoryList extends StatelessWidget {
  final List<Inventory> inventory;

  InventoryList({Key key, this.inventory}) : super(key: key);

  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: inventory.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Center(
            child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: ListTile(
                  title: Text(inventory[index].name.toString()),
                ),
              ),
              Column(children: <Widget>[
                Text('Expiration: ' + inventory[index].expiration.toString()),
                //Text('Unit: ' + inventory[index].unit.toString()),
                //Text('Quantity: ' + inventory[index].quantity.toString()),
                Text('Acquisition: ' + inventory[index].acquisition.toString()),
              ])
            ],
          ),
        ));
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
