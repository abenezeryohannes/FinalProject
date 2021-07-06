// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suspect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suspect _$SuspectFromJson(Map<String, dynamic> json) {
  return Suspect(
    status: json['status'] as String,
    title: json['title'] as String,
    message: json['message'] as String
  );
}

Map<String, dynamic> _$SuspectToJson(Suspect instance) =>
    <String, dynamic>{
      'status': instance.status,
      'title': instance.title,
      'message': instance.message,
    };
