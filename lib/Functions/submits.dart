/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/

import 'package:flutter/material.dart';

import 'package:MarkIt/Pages/AssessmentPage.dart';
import 'package:MarkIt/Pages/StudentsPage.dart';

import '../Widgets/global_widgets.dart';

import '../Models/Criterion.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<bool> toggleActivation(String assID, context) async{
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator(),);
      });
  var now = DateTime.now();
  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({"request": "TOGGLE_ACTIVATION", "assessment_id":  assID}));
  Navigator.pop(context);

  refreshAssList();
  print("response time = "+(DateTime.now().difference(now)).toString());
  if (response.statusCode == 200) {

    print('response code:  200\n');
    print('response body: ' + response.body);
    print(assID);
    await showDialog_2(context,"","Successfully toggled" ,"Close");
    return true;
  } else if (response.statusCode == 409) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    await showDialog_2(context,"","Error in toggling" ,"Close");
    return false;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    await showDialog_2(context,"","Error in toggling" ,"Close");
    return false;
  }

}

Future<bool> addTutor(String tutorName, String subjectId, context) async{
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator(),);
      });

  var response = await http.post('https://markit.mijdas.com/api/subject/',
      body: jsonEncode({"request": "ADD_TUTOR", "tutors":  [tutorName],"subject_id":subjectId}));
  Navigator.pop(context);

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    showDialog_1(context, "Success!",
        "Tutor added successfully.", "Close", true);
    return true;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    return false;
  }
}

Future<bool> addStudent(String sName, String subjectId, context) async{
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator(),);
      });

  var response = await http.post('https://markit.mijdas.com/api/subject/',
      body: jsonEncode({"request": "ADD_STUDENTS", "subject_id":  subjectId,"students":[sName]}));

  Navigator.pop(context);

  if (response.statusCode == 200) {

    print('response code:  200\n');
    print('response body: ' + response.body);
    await showDialog_2(context, "Success!",
        "Student added successfully", "Close");

    return true;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    return false;
  }

}

Future<bool> postMark(List<Criterion> _criteriaPost, String _student, String _a,  context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator(),);
      });

  String encodeJson = json.encode({
    "request": "SUBMIT_MARK",
    "student": _student,
    "assessment_id": _a,
    "results": List<dynamic>.from(_criteriaPost.map((x) => x.toJson())),
  });

  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: encodeJson);

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    await refreshStudentsList();
    print("REFRESH FIN");
    Navigator.pop(context);
    await showDialog_2(context, "Success!",
        "Student Marks Submitted Successfully.", "Close");
    Navigator.pop(context);
    Navigator.pop(context);
    showSearch(context: context, delegate: StudentSearch());
    return true;
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    Navigator.pop(context);
    return false;
  } else {
    Navigator.pop(context);
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}