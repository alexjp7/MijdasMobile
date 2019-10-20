import '../Models/IndividualCriteria.dart';


class Student {
  String studentId;
  String result;
  List<IndividualCriteria> criteria;

  Student({
    this.studentId,
    this.result,
    this.criteria,
  });

  factory Student.fromJson(Map<String, dynamic> json) => new Student(
    studentId: json["student_id"],
    // result: json["result"],
    result: json["result"] == null ? null : json["result"],
    criteria: List<IndividualCriteria>.from(
            json["criteria"].map((x) => IndividualCriteria.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    // "result": result,
    "result": result == null ? null : result,
  };
}

// List<Student> criteriaDecodeFromJson(String str) =>
//     List<Student>.from(
//         json.decode(str).map((x) => Student.fromJson(x)));

