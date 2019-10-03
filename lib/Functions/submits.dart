/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/

import '../Widgets/global_widgets.dart';

import '../Models/Criterion.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<String> toggleActivation(String assessment_id) async{
  var now = DateTime.now();
  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({"request": "TOGGLE_ACTIVATION", "assessment_id":  assessment_id}));

  print("response time = "+(DateTime.now().difference(now)).toString());
  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    print(assessment_id);
    return "Success";
  } else if (response.statusCode == 409) {
    print('response code:  200\n');
    print('response body: ' + response.body);
   // print(assessment_id);
    return response.body;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    return response.body;
  }

}

Future<bool> addTutor(String tutorName, String subjectId) async{

  var response = await http.post('https://markit.mijdas.com/api/subject/',
      body: jsonEncode({"request": "ADD_TUTOR", "tutors":  [tutorName],"subject_id":subjectId}));

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return true;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    return false;
  }
}

Future<bool> addStudent(String sName, String subjectId) async{

  var response = await http.post('https://markit.mijdas.com/api/subject/',
      body: jsonEncode({"request": "ADD_STUDENTS", "subject_id":  subjectId,"students":[sName]}));

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return true;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    return false;
  }

}

Future<bool> postMark(List<Criterion> _criteriaPost, String _student, String _a,  _critContext) async {
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
    showDialog_1(_critContext, "Success!",
        "Student Marks Submitted Successfully.", "Close", true);
    return true;
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    return false;
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}