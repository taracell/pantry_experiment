// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return BaseResponse(
      (json['items'] as List)
          ?.map((e) =>
              e == null ? null : Item.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      code: json['code'] as String,
      total: json['total'] as int,
      offset: json['offset'] as int);
}

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'total': instance.total,
      'offset': instance.offset,
      'items': instance.item
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      title: json['title'] as String,
      upc: json['upc'] as String,
      brand: json['brand'] as String);
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'title': instance.title,
      'upc': instance.upc,
      'brand': instance.brand
    };
