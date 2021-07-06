import 'package:json_annotation/json_annotation.dart';
part 'setting.g.dart';

@JsonSerializable()
class Setting{
  String language;
  int walkthrough;
  int signup;
  int ad = 0;
  
  Setting({this.language, this.walkthrough, this.signup, this.ad});


  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$SettingToJson(this);

@override
  String toString(){
    return "setting: $language";
  }
}