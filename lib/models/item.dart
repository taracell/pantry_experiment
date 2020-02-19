import 'package:json_annotation/json_annotation.dart';
part 'item.g.dart';

@JsonSerializable()
class Item {
  final String name;
  final String acquisition;
  final String quantity_with_unit;
  final String expiration;

  Item({this.name, this.acquisition, this.expiration, this.quantity_with_unit});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
} //Inventory
