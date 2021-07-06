// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'setting.dart';
// **************************************************************************
// JsonSerializableGenerator 
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return Setting(
    language: json['language'] as String,
    walkthrough: json['walkthrough'] as int,
    signup: json['signup'] as int,
    ad: json['ad'] as int
  );
}

Map<String, dynamic> _$SettingToJson(Setting instance) =>
    <String, dynamic>{
      'language': instance.language,
      'walkthrough': instance.walkthrough,
      'signup': instance.signup,
      'ad': instance.ad,
    };
