// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalData _$GlobalDataFromJson(Map<String, dynamic> json) {
  return GlobalData(
    total_cases: json['total_cases'] as int,
    total_recovered: json['total_recovered'] as int,
    total_unresolved: json['total_unresolved'] as int,
    total_deaths: json['total_deaths'] as int,
    total_new_cases_today: json['total_new_cases_today'] as int,
    total_new_deaths_today: json['total_new_deaths_today'] as int,
    total_active_cases: json['total_active_cases'] as int,
    total_serious_cases: json['total_serious_cases'] as int,
  );
}

Map<String, dynamic> _$GlobalDataToJson(GlobalData instance) =>
    <String, dynamic>{
      'total_cases': instance.total_cases,
      'total_recovered': instance.total_recovered,
      'total_unresolved': instance.total_unresolved,
      'total_deaths': instance.total_deaths,
      'total_new_cases_today': instance.total_new_cases_today,
      'total_new_deaths_today': instance.total_new_deaths_today,
      'total_active_cases': instance.total_active_cases,
      'total_serious_cases': instance.total_serious_cases,
    };
