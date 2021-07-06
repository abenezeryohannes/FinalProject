// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoCategory _$InfoCategoryFromJson(Map<String, dynamic> json) {
  return InfoCategory(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$InfoCategoryToJson(InfoCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
