import 'dart:convert';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'upc_base_response.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Scan extends StatefulWidget {
  @override
  ScanState createState() => new ScanState();
}

class ScanState extends State<Scan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String barcode = '';
  http.Client client = new http.Client();
  BaseResponse baseResponse = BaseResponse();

  /// Inputs to make the text go the correct direction
  var itemController = TextEditingController();
  var quantityController = TextEditingController();
  var expirationController = TextEditingController();
  var acquisitionController = TextEditingController(text: getDate());

  @override
  void initState() {
    super.initState();
    itemController.addListener(_printItem);
    quantityController.addListener(_printQuantity);
    expirationController.addListener(_printExpiration);
    acquisitionController.addListener(_printAcquisition);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    itemController.dispose();
    quantityController.dispose();
    expirationController.dispose();
    acquisitionController.dispose();
    super.dispose();
  }

  _printItem() {
    print('${itemController.text}');
  }

  _printQuantity() {
    print('${quantityController.text}');
  }

  _printExpiration() {
    print('${expirationController.text}');
  }

  _printAcquisition() {
    print('${acquisitionController.text}');
  }

  Future<dynamic> fetchBarcodeInfo(http.Client client, String barcode) async {
    final response = await http
        .get('https://api.upcitemdb.com/prod/trial/lookup?upc=' + barcode);
    var responseBody = json.decode(response.body);
    setState(() => baseResponse = BaseResponse.fromJson(responseBody));
    print(baseResponse.items[0].title);
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
              pantryInfoInputsWidget(),
            ],
          ),
        )));
  }

  Widget pantryInfoInputsWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: itemController,
              decoration: InputDecoration(
                labelText: 'Item',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: "Quantity",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
              controller: acquisitionController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Acquisition Date',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
              controller: expirationController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Expiration Date',
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              return RaisedButton(
                onPressed: () => {}, //toJson goes between brackets
                color: Colors.teal,
                child: Text('Add Item'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget barcodeInfo() {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: (baseResponse == null ||
                      baseResponse.items == null ||
                      baseResponse.items.length == 0)
                  ? 0
                  : baseResponse.items.length,
              itemBuilder: (context, index) {
                return new Column(
                  children: <Widget>[
                    if (baseResponse.items[index] != null)
                      new ListTile(
                          title:
                              new Text(baseResponse.items[index].toString())),
                    new Divider(
                      height: 2.0,
                    ),
                  ],
                );
              }, //itemBuilder:
            ))
      ],
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      String baseResponseBody = await fetchBarcodeInfo(client, barcode);
      if (baseResponseBody == null) {
        setState(() => itemController =
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('barcode', barcode));
  }
}
