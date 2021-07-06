import 'package:json_annotation/json_annotation.dart';
part 'my_device.g.dart';


@JsonSerializable()
class MyDevice{

  int id;
  String device_name;
  String device_uuid;
  String blue_name;
  String mac_address;
  String phone_number_user;
  String phone_number_fetch;
  String full_name;
  String device_type;

  MyDevice({this.id,this.device_name, this.device_uuid, this.phone_number_user, this.phone_number_fetch,
    this.blue_name,
    this.device_type,
    this.full_name,
    this.mac_address});

  factory MyDevice.fromJson(Map<String, dynamic> json) => _$MyDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$MyDeviceToJson(this);

  @override
  String toString() {
    return 'MyDevice{id: $id, device_name: $blue_name, device_uuid: $device_uuid, phone_number:'+
        ' $phone_number_user, user_name: $full_name, device_type: $device_type, device_mac_address: $mac_address}';
  }


}