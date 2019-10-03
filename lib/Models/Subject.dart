/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
class Subject {
  String subjectCode;
  String id;

  Subject({
    this.subjectCode,
    this.id,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => new Subject(
    subjectCode: json["subject_code"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "subject_code": subjectCode,
    "id": id,
  };
}