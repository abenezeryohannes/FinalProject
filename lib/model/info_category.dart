import 'package:json_annotation/json_annotation.dart';
part 'info_category.g.dart';

@JsonSerializable()
class InfoCategory{
    int id;
    String title;
    String description;
    String image;

    InfoCategory({this.id, this.title, this.description, this.image});


    
  factory InfoCategory.fromJson(Map<String, dynamic> json) => _$InfoCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$InfoCategoryToJson(this);
}