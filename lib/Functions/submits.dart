//##################
//JOEL IDK HOW U PLAN TO USE THIS FILE SO IM CHUCKING IN
//RANDOM API STUFF I PLAN TO USE GLOBALLY, U CAN REARRANGE HOWEVER U WANT OK -MITCH
//WILL PROBS ADD THE CALLS IN AFTER MEETING, UNLESS U DO FIRST.
//CALLS TO BE ADDED: (Referenced in API Doc)
//          - '3.2.7 Add Student to Subject'
//          - '3.2.9  Add Tutor to Subject'
//          - '3.2.10  Toggle Assessment Activation'
//          - '3.2.11  Create Subject'
//          - '3.2.12  Create Criteria'
//##################

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<bool> toggleActivation(String assessment_id) async{

  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({"request": "TOGGLE_ACTIVATION", "assessment_id":  assessment_id}));

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    print(assessment_id);
    return true;
  } else{
    print('response code:  \n' + response.statusCode.toString());
    print('response body: ' + response.body);
    return false;
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