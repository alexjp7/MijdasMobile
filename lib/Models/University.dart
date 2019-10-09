/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import './Subject.dart';
import 'dart:convert';

class University {
  String institution;
  List<Subject> subjects;

  University({
    this.institution,
    this.subjects,
  });

  factory University.fromJson(Map<String, dynamic> json) => new University(
    institution: json["institution"],
    subjects: new List<Subject>.from(
        json["subjects"].map((x) => Subject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "institution": institution,
    "subjects": new List<dynamic>.from(subjects.map((x) => x.toJson())),
  };
}

List<University> universitiesFromJson(String str) =>
    new List<University>.from(
        json.decode(str).map((x) => University.fromJson(x)));