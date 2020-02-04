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

  /// Inputs
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  TextEditingController acquisitionController =
      TextEditingController(text: getDate());

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
              textInputAction: TextInputAction.continueAction,
              controller: itemController,
              onChanged: (h) => itemController.text = h,
              decoration: InputDecoration(
                labelText: 'Item',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              textInputAction: TextInputAction.continueAction,
              controller: quantityController,
              keyboardType: TextInputType.number,
              onChanged: (h) => quantityController.text = h,
              decoration: InputDecoration(
                labelText: "Quantity",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
              textInputAction: TextInputAction.continueAction,
              controller: acquisitionController,
              keyboardType: TextInputType.datetime,
              onChanged: (h) => acquisitionController.text = h,
              decoration: InputDecoration(
                labelText: 'Acquisition Date',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
              controller: expirationController,
              keyboardType: TextInputType.datetime,
              onChanged: (h) => expirationController.text = h,
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
                return ListTile(
                    title: Text('${baseResponse.items[index].title}'));
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
