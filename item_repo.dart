import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pantry/scan_screen.dart';
import 'response.dart';
import 'model.dart';

class ItemRepo {
  final http.Client client;

  ItemRepo({this.client});

  Future<List<ItemModel>> getUpcFromScan(barcode) async {
    String url;

    if (barcode != null) {
      url = 'https://api.upcitemdb.com/prod/trial/lookup?upc=' + barcode;
    } else {
      url = 'https://api.upcitemdb.com/prod/trial/lookup?upc=041196011111';
    }

    final response = await client.get(url);

    List<ItemModel> request = BaseResponse.fromJson(json.decode(response.body))
        .item
        .map((item) => ItemModel.fromResponse(item))
        .toList();

    return request;
  }
}
