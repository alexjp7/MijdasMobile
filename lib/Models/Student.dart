class Student {
  String studentId;
  String result;

  Student({
    this.studentId,
    this.result,
  });

  factory Student.fromJson(Map<String, dynamic> json) => new Student(
    studentId: json["student_id"],
    // result: json["result"],
    result: json["result"] == null ? null : json["result"],
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    // "result": result,
    "result": result == null ? null : result,
  };
}