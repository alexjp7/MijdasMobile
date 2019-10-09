import 'package:flutter/material.dart';


class Criterion {
  String criteria, element, maxMark, displayText;
  String comment;
  bool _isChecked;
  int iD, elementType;
  double maxMarkI;

  TextEditingController tControl;
  double value = 0;

  Criterion({
    this.criteria,
    this.element,
    this.maxMark,
    this.displayText,
  }) {
    if (element == "0") {
      _isChecked = true;
    } else if (element == "2") {
      tControl = TextEditingController();
    }
    if (maxMark != null) {
      value = double.parse(maxMark);
    }

    this.iD = int.parse(criteria);
    this.elementType = int.parse(element);
    if (maxMark == null) {
      this.tControl=TextEditingController();
      this.maxMarkI = -1.0;
      value = null;
    } //temp fix, although can be used to identify null boxes in future
    else
      this.maxMarkI = double.parse(maxMark);
    // this.maxMarkI = int.parse(maxMark);
  }

  // might need these later?
  // bool getChecked(){
  //   return _isChecked;
  // }
  // void setChecked(bool b){
  //   _isChecked = b;
  // }

  factory Criterion.fromJson(Map<String, dynamic> json) =>
      Criterion(
        criteria: json["criteria"],
        element: json["element"],
        maxMark: json["maxMark"] == null ? null : json["maxMark"],
        displayText: json["displayText"],
      );

  Map<String, dynamic> toJson() =>
      {"c_id": criteria, "result": value, "comment": comment};

  bool isChecked(){
    return _isChecked;
  }
  void makeChecked(bool val){
    _isChecked = val;
  }
}
