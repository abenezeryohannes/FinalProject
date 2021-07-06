import 'package:json_annotation/json_annotation.dart';
part 'global_data.g.dart';

@JsonSerializable()
class GlobalData{
  int total_cases;
  int total_recovered;
  int total_unresolved;
  int total_deaths;
  int total_new_cases_today;
  int total_new_deaths_today;
  int total_active_cases;
  int total_serious_cases;


  GlobalData({this.total_cases, this.total_recovered, this.total_unresolved, this.total_deaths, this.total_new_cases_today
  ,this.total_new_deaths_today, this.total_active_cases, this.total_serious_cases});


  factory GlobalData.fromJson(Map<String, dynamic> json) => _$GlobalDataFromJson(json);
  Map<String, dynamic> toJson() => _$GlobalDataToJson(this);

@override
  String toString(){
    return "total_cases: $total_cases total_deaths: $total_deaths total_recovered: $total_recovered";
  }
}