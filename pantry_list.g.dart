// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return Inventory(
      title: json['title'] as String,
      acquisition: json['acquisition'] as String,
      quantity: json['quantity'] as int,
      expiration: json['expiration'] as String);
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'title': instance.title,
      'acquisition': instance.acquisition,
      'expiration': instance.expiration
    };
