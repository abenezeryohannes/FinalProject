// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    macAddress: json['macAddress'] as String,
    phoneNumber: json['phoneNumber'] as String,
    caseID: json['caseID'] as int,
    suspectionPercentage: (json['suspectionPercentage'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'macAddress': instance.macAddress,
      'phoneNumber': instance.phoneNumber,
      'caseID': instance.caseID,
      'suspectionPercentage': instance.suspectionPercentage,
    };
