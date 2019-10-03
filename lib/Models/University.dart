/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import './Subject.dart';
import 'dart:convert';

class Universities {
  String institution;
  List<Subject> subjects;

  Universities({
    this.institution,
    this.subjects,
  });

  factory Universities.fromJson(Map<String, dynamic> json) => new Universities(
    institution: json["institution"],
    subjects: new List<Subject>.from(
        json["subjects"].map((x) => Subject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "institution": institution,
    "subjects": new List<dynamic>.from(subjects.map((x) => x.toJson())),
  };
}

List<Universities> universitiesFromJson(String str) =>
    new List<Universities>.from(
        json.decode(str).map((x) => Universities.fromJson(x)));