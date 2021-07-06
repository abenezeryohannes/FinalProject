import 'package:json_annotation/json_annotation.dart';
part 'country_data.g.dart';

@JsonSerializable()
class CountryData{
  String title;
  String code;
  int total_cases;
  int total_recovered;
  int total_unresolved;
  int total_deaths;
  int total_new_cases_today;
  int total_new_deaths_today;
  int total_active_cases;
  int total_serious_cases;


  CountryData({
    this.title,
    this.code,
    this.total_cases,
    this.total_recovered,
    this.total_unresolved,
    this.total_deaths,
    this.total_new_cases_today,
    this.total_new_deaths_today,
    this.total_active_cases,
    this.total_serious_cases
  });


  factory CountryData.fromJson(Map<String, dynamic> json) => _$CountryDataFromJson(json);
  Map<String, dynamic> toJson() => _$CountryDataToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "$title";
  }
}