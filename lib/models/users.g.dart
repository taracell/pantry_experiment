// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      name: json['username'] as String,
      password: json['password'] as String,
      auth: json['authorization']);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.name,
      'password': instance.password,
      'authorization': instance.auth
    };
