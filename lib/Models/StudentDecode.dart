import './Student.dart';
import 'dart:convert';

class StudentDecode {
  List<Student> records;

  StudentDecode({
    this.records,
  });

  factory StudentDecode.fromJson(Map<String, dynamic> json) =>
      new StudentDecode(
        records: new List<Student>.from(
            json["records"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "records": new List<dynamic>.from(records.map((x) => x.toJson())),
  };
}

List<StudentDecode> studentDecodeFromJson(String str) =>
    new List<StudentDecode>.from(
        json.decode(str).map((x) => StudentDecode.fromJson(x))); 

        