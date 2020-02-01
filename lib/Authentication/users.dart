import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

const userLoginData = const {
  'foo@gmail.com': 'barbar',
  'bar@gmail.com': 'foofoo'
};

@JsonSerializable()
class User {
  final String uid;
  final String pwd;

  User({this.uid, this.pwd});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
