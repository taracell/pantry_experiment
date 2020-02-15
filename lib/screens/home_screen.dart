import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'scan_screen.dart';
import 'package:pantry/data/connect_repository.dart';
import 'package:pantry/models/inventory.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final widgetOptions = [
    PantryList(),
    Text('Search/Filter'),
    Text('Expires First'),
    Scan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantry Application '),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library), title: Text('Inventory')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('Expiring')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('Add Item')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.teal,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class PantryList extends StatefulWidget {
  PantryList({Key key}) : super(key: key);
  @override
  PantryListState createState() => PantryListState();
}

class PantryListState extends State<PantryList> {
  Future<Inventory> inventory;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<List<Inventory>>(
                future: fetchInventory(http.Client(), context),
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
