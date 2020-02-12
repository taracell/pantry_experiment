import 'dart:convert';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pantry/home_screen.dart';
import 'package:pantry/pantry_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'upc_base_response.dart';
import 'package:http/http.dart' as http;
import 'fade_route.dart';

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

//TODO - Change url to correct url for post/get.
  String url = 'http://localhost:8000/item'; //iOS TESTING
  //String url = 'http://10.0.2.2:8000/item/'; //ANDROID TESTING
  //String url = 'https://14186d37-8753-4052-924a-c403f155a8bb.mock.pstmn.io';

  /// Inputs
  var itemController = TextEditingController();
  var quantityController = TextEditingController();
  var unitController = TextEditingController();

  ///Used for JSON compatibility
  String acquisition;
  String expiration;
  String unit;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    itemController.dispose();
    quantityController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    itemController.addListener(_itemController);
    quantityController.addListener(_quantityController);
    unitController.addListener(_unitController);
  }

  _itemController() {
    print("${itemController.text}");
  }

  _quantityController() {
    print("${quantityController.text}");
  }

  _unitController() {
    print("${unitController.text}");
  }

  Future<dynamic> fetchBarcodeInfo(http.Client client, String barcode) async {
    final response = await http
        .get('https://api.upcitemdb.com/prod/trial/lookup?upc=' + barcode);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      setState(() => baseResponse = BaseResponse.fromJson(responseBody));
      return baseResponse;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load item');
    }
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
              controller: itemController,
              decoration: InputDecoration(
                labelText: 'Item: What is it?',
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                labelText: "Quantity:  How many?",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 4.0),
          child: TextField(
              controller: unitController,
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
                setState(() => acquisition = dt.toIso8601String()),
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
                setState(() => expiration = dt.toIso8601String()),
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
      BaseResponse baseResponseBody = await fetchBarcodeInfo(client, barcode);
      if (baseResponseBody != null) {
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

  Future addToInventory(context) async {
    Inventory inventory = new Inventory(
        name: "${itemController.text}",
        acquisition: acquisition,
        //unit: "${unitController.text}",
        //quantity: int.parse("${quantityController.text}"),
        expiration: expiration);

    var responseBody = json.encode(inventory);
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: responseBody);
    if (response.statusCode == 200) {
      _alertSuccess(context);
      return response;
    } else {
      print("Item Not Added to Pantry");
      _alertFail(context);
      throw Exception('Failed to load to Inventory');
      // If that call was not successful, throw an error.
    }
  }

  void _alertSuccess(context) {
    new Alert(
      context: context,
      type: AlertType.info,
      title: "Information",
      desc: "Item Added to Pantry.",
      buttons: [
        DialogButton(
          child: Text(
            "Transfer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.teal,
          onPressed: () => Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => HomeScreen(),
          )),
        ),
      ],
    ).show();
  }

  void _alertFail(context) {
    new Alert(
      context: context,
      type: AlertType.error,
      title: "ERROR",
      desc: "Item NOT Added to Pantry. Please check your input and try again",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.teal,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ).show();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('barcode', barcode));
  }
}
