import './Subject.dart';

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