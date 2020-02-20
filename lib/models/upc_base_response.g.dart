// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upc_base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return BaseResponse(
      code: json['code'] as String,
      total: json['total'] as int,
      offset: json['offset'] as int,
      items: (json['items'] as List)
          ?.map((e) =>
              e == null ? null : Items.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'total': instance.total,
      'offset': instance.offset,
      'items': instance.items
    };

Items _$ItemsFromJson(Map<String, dynamic> json) {
  return Items(
      ean: json['ean'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      upc: json['upc'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      color: json['color'] as String,
      size: json['size'] as String,
      dimension: json['dimension'] as String,
      weight: json['weight'] as String,
      currency: json['currency'] as String,
      lowestRecordedPrice: json['lowestRecordedPrice'] as int,
      highestRecordedPrice: (json['highestRecordedPrice'] as num)?.toDouble(),
      images: (json['images'] as List)?.map((e) => e as String)?.toList(),
      offers: (json['offers'] as List)
          ?.map((e) =>
              e == null ? null : Offer.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      asin: json['asin'] as String,
      elid: json['elid'] as String);
}

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'ean': instance.ean,
      'title': instance.title,
      'description': instance.description,
      'upc': instance.upc,
      'brand': instance.brand,
      'model': instance.model,
      'color': instance.color,
      'size': instance.size,
      'dimension': instance.dimension,
      'weight': instance.weight,
      'currency': instance.currency,
      'lowestRecordedPrice': instance.lowestRecordedPrice,
      'highestRecordedPrice': instance.highestRecordedPrice,
      'images': instance.images,
      'offers': instance.offers,
      'asin': instance.asin,
      'elid': instance.elid
    };

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return Offer(
      merchant: json['merchant'] as String,
      domain: json['domain'] as String,
      title: json['title'] as String,
      currency: json['currency'] as String,
      listPrice: json['listPrice'] as String,
      price: (json['price'] as num)?.toDouble(),
      shipping: json['shipping'] as String,
      link: json['link'] as String,
      updatedT: json['updatedT'] as int);
}

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'merchant': instance.merchant,
      'domain': instance.domain,
      'title': instance.title,
      'currency': instance.currency,
      'listPrice': instance.listPrice,
      'price': instance.price,
      'shipping': instance.shipping,
      'link': instance.link,
      'updatedT': instance.updatedT
    };
