// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'mini_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiniDevice _$MiniDeviceFromJson(Map<String, dynamic> json) {
  return MiniDevice(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      accuracy: json['accuracy'] as double,
      altitude: json['altitude'] as double,
      device_name: json['device_name'] as String,
      device_uuid: json['device_uuids'] as String,
      device_rssi: json['device_rssi'] as int,
      address: json['address'] as String,
  );
}

Map<String, dynamic> _$MiniDeviceToJson(MiniDevice instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'altitude': instance.altitude,
      'device_name': instance.device_name,
      'device_uuid': instance.device_uuid,
      'device_rssi': instance.device_rssi,
      'address': instance.address,
    };
