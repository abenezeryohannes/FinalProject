import 'package:json_annotation/json_annotation.dart';
part 'suspect.g.dart';

@JsonSerializable()
class Suspect{
  String status;
  String title;
  String message;
  
  
  Suspect({this.title, this.message, this.status});
  factory Suspect.fromJson(Map<String, dynamic> json) => _$SuspectFromJson(json);
  Map<String, dynamic> toJson() => _$SuspectToJson(this);


  
  String toString(){return "mac_address: $status title: $title suspection: $message ";}
}
