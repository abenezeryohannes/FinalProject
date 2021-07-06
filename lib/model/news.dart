import 'package:json_annotation/json_annotation.dart';
part 'news.g.dart';

@JsonSerializable()
class News {
  int id;
  String country;
  String title;
  String description;
  String source;
  String time;
  String image_url;

  News({this.id, this.country, this.title, this.description, this.source, this.time, this.image_url});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "id: $id $image_url";
  }
}