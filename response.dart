import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable()
class BaseResponse extends Object {
  final String code;
  final int total;
  final int offset;

  BaseResponse(this.item, {this.code, this.total, this.offset});

  @JsonKey(name: "items")
  final List<Item> item;

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
}

@JsonSerializable()
class Item extends Object {
  @JsonKey(nullable: true)
  final String title;
  final String upc;
  @JsonKey(nullable: true)
  final String brand;

  Item({this.title, this.upc, this.brand});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
