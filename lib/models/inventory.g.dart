// GENERATED CODE - DO NOT MODIFY BY HAND

part of './inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return Inventory(
      name: json['name'] as String,
      quantity_with_unit: json['quantity_with_unit'] as String,
      acquisition: json['acquisition_date'] as String,
      expiration: json['expiration_date'] as String);
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'name': instance.name,
      'quantity_with_unit': instance.quantity_with_unit,
      'acquisition_date': instance.acquisition,
      'expiration_date': instance.expiration
    };
