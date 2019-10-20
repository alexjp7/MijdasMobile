import 'package:flutter/material.dart';


class IndividualCriteria {
  String id, comment, result;

  IndividualCriteria({
    this.id,
    this.comment,
    this.result,
  });

  factory IndividualCriteria.fromJson(Map<String, dynamic> json) =>
      IndividualCriteria(
        id: json["id"],
        result: json["result"] == null ? null : json["result"],
        comment: json["comment"] == null ? null : json["comment"],
      );

  Map<String, dynamic> toJson() =>
      {"c_id": id, "result": result, "comment": comment};

}
