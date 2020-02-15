import 'package:json_annotation/json_annotation.dart';
part 'inventory.g.dart';

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
