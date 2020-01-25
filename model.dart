import "response.dart";

class ItemModel {
  final String title;
  final String upc;
  final String brand;

  ItemModel({this.title, this.upc, this.brand});

  ItemModel.fromResponse(Item response)
      : title = response.title,
        upc = response.upc,
        brand = response.brand;
}
