import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'upc_base_response.g.dart';

BaseResponse baseResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

@JsonSerializable()
class BaseResponse {
  final String code;
  final int total;
  final int offset;
  final List<Item> items;

  BaseResponse({
    this.code,
    this.total,
    this.offset,
    this.items,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}

@JsonSerializable()
class Item {
  final String ean;
  final String title;
  final String description;
  final String upc;
  final String brand;
  final String model;
  final String color;
  final String size;
  final String dimension;
  final String weight;
  final String currency;
  final int lowestRecordedPrice;
  final double highestRecordedPrice;
  final List<String> images;
  final List<Offer> offers;
  final String asin;
  final String elid;

  Item({
    this.ean,
    this.title,
    this.description,
    this.upc,
    this.brand,
    this.model,
    this.color,
    this.size,
    this.dimension,
    this.weight,
    this.currency,
    this.lowestRecordedPrice,
    this.highestRecordedPrice,
    this.images,
    this.offers,
    this.asin,
    this.elid,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Offer {
  final String merchant;
  final String domain;
  final String title;
  final String currency;
  final String listPrice;
  final double price;
  final String shipping;
  final String link;
  final int updatedT;

  Offer({
    this.merchant,
    this.domain,
    this.title,
    this.currency,
    this.listPrice,
    this.price,
    this.shipping,
    this.link,
    this.updatedT,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
