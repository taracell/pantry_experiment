import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'item_repo.dart';
import 'package:http/http.dart' as http;

class Scan extends StatefulWidget {
  @override
  ScanState createState() => new ScanState();
}

class ScanState extends State<Scan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String barcode = "";

  /// Inputs
  TextEditingController itemController = TextEditingController();
  TextEditingController manufactureController = TextEditingController();
  TextEditingController expirationController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Center(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              new Container(
                child: new MaterialButton(
                    onPressed: scan, child: new Text("Scan")),
                padding: const EdgeInsets.all(8.0),
              ),
              new Text(barcode),
              pantryInfoInputsWidget()
            ],
          ),
        )));
  }

  Widget pantryInfoInputsWidget() {
    ItemRepo item = new getUpcFromScan(barcode);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: itemController,
              onChanged: itemController.text = re,
              decoration: InputDecoration(
                labelText: 'Item',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: manufactureController,
              onChanged: (v) => manufactureController.text = v,
              decoration: InputDecoration(
                labelText: "Manufacture",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
              controller: expirationController,
              onChanged: (v) => expirationController.text = v,
              decoration: InputDecoration(
                labelText: 'Expiration Date',
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              return RaisedButton(
                onPressed: () => {},
                color: Colors.teal,
                child: Text('Add Item'),
              );
            },
          ),
        ),
      ],
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
