// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    accuracy: json['accuracy'] as double,
    altitude: json['altitude'] as double,
    time: json['time'] as double
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'altitude': instance.altitude,
      'time': instance.time
    };
