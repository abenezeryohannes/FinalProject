import 'package:json_annotation/json_annotation.dart';
part 'connection.g.dart';

@JsonSerializable()
class Connection{

    int connectionId;
    String macAdderss1;
    String macAddress2;
    double minimumDistance;

    Connection({this.connectionId, this.macAdderss1, this.macAddress2, this.minimumDistance});



  factory Connection.fromJson(Map<String, dynamic> json) => _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);
}