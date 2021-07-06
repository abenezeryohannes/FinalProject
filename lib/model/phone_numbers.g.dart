// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_numbers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumbers _$PhoneNumbersFromJson(Map<String, dynamic> json) {
  return PhoneNumbers(
    id: json['id'] as int,
    phone_number: json['phone_number'] as String,
    region_name: json['region'] as String,

  );
}

Map<String, dynamic> _$PhoneNumbersToJson(PhoneNumbers instance) => <String, dynamic>{
  'id': instance.id,
  'phone_number': instance.phone_number,
  'region': instance.region_name,
};
