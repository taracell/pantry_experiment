// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return Inventory(
      name: json['name'] as String,
      //acquisition: json['acquisition'] as String,
      //unit: json['unit'] as String,
      //quantity: json['quantity'] as int,
      //expiration: json['expiration'] as String);
      acquisition: json['acquisition_date'] as String,
      expiration: json['expiration_date'] as String);
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      //'quantity': instance.quantity,
      'name': instance.name,
      //'unit': instance.unit,
      'acquisition_date': instance.acquisition,
      'expiration_date': instance.expiration
    };
