import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable()
class Location{
  double latitude;
  double longitude;
  double altitude;
  double accuracy;
  double time;

  Location({this.longitude, this.latitude, this.altitude, this.accuracy, this.time});
  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}