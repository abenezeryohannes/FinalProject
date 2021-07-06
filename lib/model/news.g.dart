// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    id: json['id'] as int,
    image_url: json['image'] as String,
    country: json['country'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    source: json['source'] as String,
    time: json['time'] as String,

  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'country': instance.country,
  'description': instance.description,
  'source': instance.source,
  'time': instance.time,
  'image': instance.image_url,
};
