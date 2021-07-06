
import 'package:json_annotation/json_annotation.dart';
part 'info.g.dart';

@JsonSerializable()
class Info{
    int id;
    int category_id;
    String title;
    String description;
    String image;

    Info({this.id,this.category_id, this.title, this.description, this.image});



  @override
  String toString(){
    return "id: $id category_id: $category_id title: $title";
  }

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
