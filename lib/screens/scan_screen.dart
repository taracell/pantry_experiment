import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/upc_base_response.dart';
import '../data/connect_repository.dart';

class Connections {
  /// Inputs
  static var itemController = TextEditingController();
  static var quantityController = TextEditingController();
  static var unitController = TextEditingController();

  ///Used for JSON compatibility
  static String acquisition;
  static String expiration;
  static String unit;
}

class Scan extends StatefulWidget {
  @override
  ScanState createState() => new ScanState();
}

class ScanState extends State<Scan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String barcode = '';
  http.Client client = new http.Client();
  BaseResponse baseResponse = new BaseResponse();
  var formatter = new DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    Connections.itemController.dispose();
    Connections.quantityController.dispose();
    Connections.unitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Connections.itemController.addListener(_itemController);
    Connections.quantityController.addListener(_quantityController);
    Connections.unitController.addListener(_unitController);
  }

  _itemController() {
    print("${Connections.itemController.text}");
  }

  _quantityController() {
    print("${Connections.quantityController.text}");
  }

  _unitController() {
    print("${Connections.unitController.text}");
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
                child: new RaisedButton(
                    onPressed: scan,
                    color: Colors.teal,
                    child: new Text("Scan")),
                padding: const EdgeInsets.all(8.0),
              ),
              new Text(barcode),
              pantryInfoInputsWidget(context),
            ],
          ),
        )));
  }

  Widget pantryInfoInputsWidget(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: Connections.itemController,
              decoration: InputDecoration(
                labelText: 'Item: What is it?',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: Connections.quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                labelText: "Quantity:  How many?",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: Connections.unitController,
              decoration: InputDecoration(
                labelText: "Unit: How much?",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: DateTimeField(
            format: formatter,
            decoration: InputDecoration(labelText: 'Acquisition Date'),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
            onChanged: (dt) =>
                setState(() => Connections.acquisition = dt.toIso8601String()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: DateTimeField(
            format: formatter,
            decoration: InputDecoration(
              labelText: 'Expiration Date',
            ),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
            onChanged: (dt) =>
                setState(() => Connections.expiration = dt.toIso8601String()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              return RaisedButton(
                onPressed: () => addToInventory(context),
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
      baseResponse = await fetchBarcodeInfo(client, barcode);
      if (baseResponse != null) {
        setState(() => Connections.itemController =
            TextEditingController(text: '${baseResponse.items[0].title}'));
      }
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
