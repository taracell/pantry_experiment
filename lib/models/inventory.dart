import 'package:json_annotation/json_annotation.dart';
part 'inventory.g.dart';

@JsonSerializable()
class Inventory {
  final String name;
  final String acquisition;
  //final String unitType;
  final String expiration;

  Inventory({this.name, this.acquisition, this.expiration});

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
} //Inventory
