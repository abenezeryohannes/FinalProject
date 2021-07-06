import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User{

    int id;
    String macAddress;
    String phoneNumber;
    int caseID;
    double suspectionPercentage;
    

    User({this.id, this.macAddress, this.phoneNumber, this.caseID, this.suspectionPercentage});
   
   
  @override
  String toString() {
    return "mac address: "+macAddress+" \n"
          + "phone number: "+phoneNumber+" \n";
  }

  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}