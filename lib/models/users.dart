import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String password;
  final String auth;

  User({this.name, this.password, this.auth});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
