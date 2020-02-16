// GENERATED CODE - DO NOT MODIFY BY HAND

part of './inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return Inventory(
      name: json['name'] as String,
      //unitType: json['unit_type'] as String,
      acquisition: json['acquisition_date'] as String,
      expiration: json['expiration_date'] as String);
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'name': instance.name,
      //'unit_type': instance.unitType,
      'acquisition_date': instance.acquisition,
      'expiration_date': instance.expiration
    };
