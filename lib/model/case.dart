import 'package:json_annotation/json_annotation.dart';
part 'case.g.dart';

@JsonSerializable()
class Case{
  int id;
  String name;


  Case({this.id, this.name});

  String getName(){
    return name;
  }




  factory Case.fromJson(Map<String, dynamic> json) => _$CaseFromJson(json);
  Map<String, dynamic> toJson() => _$CaseToJson(this);
}