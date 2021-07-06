// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) {
  return Info(
    id: json['id'] as int,
    category_id: json['category_id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'id': instance.id,
      'category_id': instance.category_id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
