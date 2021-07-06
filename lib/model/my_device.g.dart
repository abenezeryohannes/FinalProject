// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyDevice _$MyDeviceFromJson(Map<String, dynamic> json) {
  return MyDevice(
      id: json['id'] as int,
      device_type: json['device_type'] as String,
      device_uuid: json['device_uuid'] as String,
      blue_name: json['blue_name'] as String,
      phone_number_user: json['phone_number_user'] as String,
      phone_number_fetch: json['phone_number_fetch'] as String,
      full_name: json['full_name'] as String,
      mac_address: json['mac_address'] as String
  );
}

Map<String, dynamic> _$MyDeviceToJson(MyDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_name': instance.device_name,
      'device_type': instance.device_type,
      'device_uuid': instance.device_uuid,
      'full_name': instance.full_name,
      'device_name': instance.blue_name,
      'mac_address': instance.mac_address,
      'phone_number_fetch': instance.phone_number_fetch,
      'phone_number_user': instance.phone_number_user
    };
