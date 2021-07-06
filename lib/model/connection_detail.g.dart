// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionDetail _$ConnectionDetailFromJson(Map<String, dynamic> json) {
  return ConnectionDetail(
    connectionId: json['connectionId'] as int,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    distance: (json['distance'] as num)?.toDouble(),
    location1: json['location1'] == null
        ? null
        : Location.fromJson(json['location1'] as Map<String, dynamic>),
    location2: json['location2'] == null
        ? null
        : Location.fromJson(json['location2'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConnectionDetailToJson(ConnectionDetail instance) =>
    <String, dynamic>{
      'connectionId': instance.connectionId,
      'time': instance.time?.toIso8601String(),
      'distance': instance.distance,
      'location1': instance.location1,
      'location2': instance.location2,
    };
