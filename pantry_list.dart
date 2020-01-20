import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PantryList extends StatefulWidget {
  PantryList({Key key}) : super(key: key);

  @override
  PantryListState createState() => PantryListState();
}

class PantryListState extends State<PantryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      child: new Center(
        child: new FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/pantryInv.json'),
            builder: (context, snapshot) {
              var items = json.decode(snapshot.data.toString());

              return new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var item = items[index];
                  return new Card(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Text("item: " + item['item'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                        new Text("manufacture: " + item['manufacture'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20)),
                        new Text("expiration: " + item['expiration'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20)),
                      ],
                    ),
                  );
                },
                itemCount: items == null ? 0 : items.length,
              );
            }),
      ),
    ));
  }
}
