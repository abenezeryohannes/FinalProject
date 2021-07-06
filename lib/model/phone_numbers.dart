import 'package:json_annotation/json_annotation.dart';
part 'phone_numbers.g.dart';

@JsonSerializable()
class PhoneNumbers{
  int id;
  String region_name;
  String phone_number;

  PhoneNumbers({this.id, this.region_name, this.phone_number});

  factory PhoneNumbers.fromJson(Map<String, dynamic> json) => _$PhoneNumbersFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumbersToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "id: $id $region_name $phone_number";
  }

}