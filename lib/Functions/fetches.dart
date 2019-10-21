/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/

import 'dart:io';

import '../Models/QueryManager.dart';

import '../Models/CriteriaDecode.dart';
import '../Models/StudentDecode.dart';
import '../Models/Assessment.dart';
import '../Models/University.dart';

import '../Widgets/global_widgets.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<CriteriaDecode>> fetchCriteria(String i) async {
  print('aaaaaaaaaaaaaa');
  var response = await http.post('https://markit.mijdas.com/api/criteria/',
      body: jsonEncode({"request": "VIEW_CRITERIA", "assessment_id": i, "token":QueryManager().token}));
  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);

    List<CriteriaDecode> rValue = criteriaDecodeFromJson(response.body);

    return rValue;
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    // showDialog_1(_assessmentContext, "Error!", "Response Code: 404.\n\n\t\t\tNo Assessments Found.", "Close & Return");
    //navigate to an error page displaying lack of assessment error
    // return assessmentsFromJson(response.body);
    return List<CriteriaDecode>();
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

Future<List<StudentDecode>> fetchStudents(String s, _studentContext) async {
  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({"request": "POPULATE_STUDENTS", "assessment_id": s, "token":QueryManager().token}));

  if (response.statusCode == 200) {
    QueryManager().criteriaList = await fetchCriteria(s);
    return studentDecodeFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    showDialog_1(
        _studentContext,
        "No students",
        "Sorry, it looks like there aren't any students enrolled in this subject, please contact you're coordinator.",
        "Close & Return",
        false);
    return null;
  } else {
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

Future<List<Assessment>> fetchAssessments(
    String s, context, bool isPriv) async {
  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({
        "request": "VIEW_ASSESSMENT",
        "subject_id": s,
        "is_coordinator": (isPriv),
        "token":QueryManager().token
      }));

  if (response.statusCode == 200) {
    return assessmentsFromJson(response.body);
  } else if (response.statusCode == 404) {
    showDialog_1(
        context,
        "No assessments",
        "Sorry, No assessments found for this subject, please contact your co-ordinator",
        "Close & Return",
        false);
    return null;
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

Future<List<University>> fetchUniversities(
    String s, _homeContext, bool isCoord) async {
  String _request;

  //IF IS COORD ONLY RETURN COORDINATOR SUBJECTS
  if (isCoord)
    _request = "VIEW_OWNED_SUBJECTS";
  else
    _request = "POPULATE_SUBJECTS";

  var response = await http.post(
      'https://markit.mijdas.com/api/requests/subject/',
      body: jsonEncode({"request": _request, "username": s, "token":QueryManager().token}));

  if (response.statusCode == 200) {
    return universitiesFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    showDialog_1(
        _homeContext,
        "No subjects",
        "Sorry, it looks like you aren't enrolled to tutor any subjects, please contact your coordinator to get started.",
        "Close & Return",
        false);
    return null;
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}
