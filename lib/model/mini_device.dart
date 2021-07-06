import 'package:json_annotation/json_annotation.dart';
part 'mini_device.g.dart';

@JsonSerializable()
class MiniDevice{
  double latitude;
  double longitude;
  double altitude;
  double accuracy;
  String device_name;
  String device_uuid;
  int device_rssi;
  String address;



  MiniDevice({this.longitude, this.latitude, this.altitude, this.accuracy, this.device_name, this.device_uuid, this.device_rssi, this.address});
  factory MiniDevice.fromJson(Map<String, dynamic> json) => _$MiniDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$MiniDeviceToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return " device_name $device_name rssi $device_rssi  address $address";
  }
}