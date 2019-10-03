import '../Models/Criterion.dart';


import 'dart:convert';



class CriteriaDecode {
  List<Criterion> criteria;

  CriteriaDecode({
    this.criteria,
  });

  factory CriteriaDecode.fromJson(Map<String, dynamic> json) =>
      CriteriaDecode(
        criteria: List<Criterion>.from(
            json["records"].map((x) => Criterion.fromJson(x))),
      );

}

List<CriteriaDecode> criteriaDecodeFromJson(String str) =>
    List<CriteriaDecode>.from(
        json.decode(str).map((x) => CriteriaDecode.fromJson(x)));

