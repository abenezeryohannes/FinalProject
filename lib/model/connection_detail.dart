import 'package:ethiocare/Model/location.dart';
import 'package:json_annotation/json_annotation.dart';
part 'connection_detail.g.dart';

@JsonSerializable()
class ConnectionDetail{
    int connectionId;
    DateTime time;
    double distance;
    Location location1;
    Location location2;


    ConnectionDetail({this.connectionId, this.time, this.distance, this.location1, this.location2});



  factory ConnectionDetail.fromJson(Map<String, dynamic> json) => _$ConnectionDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionDetailToJson(this);
}