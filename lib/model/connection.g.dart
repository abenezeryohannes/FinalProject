// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) {
  return Connection(
    connectionId: json['connectionId'] as int,
    macAdderss1: json['macAdderss1'] as String,
    macAddress2: json['macAddress2'] as String,
    minimumDistance: (json['minimumDistance'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'connectionId': instance.connectionId,
      'macAdderss1': instance.macAdderss1,
      'macAddress2': instance.macAddress2,
      'minimumDistance': instance.minimumDistance,
    };
