/*
TODO----------
-add slider incerements
-fix http
-add submit button

 */

//Got lost trying to figure multi pages out - will need it explained after/before meeting pls xoxo - this code is ready for posts - joel
import 'package:flutter/material.dart';
import 'package:mijdas_app/assessment.dart' as prefix0;

//local imports
import './home.dart';
import './students.dart';
import './assessment.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Student selectedStudent;
String assId;

Route CriteriaRoute(Student s, String assID) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CriteriaPageState(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      selectedStudent = s; //assigning page ID
      assId = assID;
      print(selectedStudent.studentId);
      print(assID);
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class CriteriaPageState extends StatefulWidget {
  //List<Criterion> items = List<Criterion>.generate(10, (i) => new Criterion("Criterea $i",i,i%3,(((i%3)*5)+5),1.0));

  @override
  CriteriaPage createState() => CriteriaPage();
}

class CriteriaPage extends State<CriteriaPageState> {
  Color _accentColour = Color(0xffBFD4DF);

  List<Criterion> items;

  CriteriaPage();

  Widget _buildTiles(int index) {
    if (items[index].element == 0) {
      return Flexible(
          flex: 1,
          child: Slider(
            min: 0.0,
            max: double.parse(items[index].maxMark),
            onChanged: (newSliderValue) {
              setState(() {
                items[index].value = newSliderValue.roundToDouble();
              });
            },
            value: items[index].value,
          ));
    } else if (items[index].element == 1) {
      items[index].value = 0;
      return Flexible(
          flex: 1,
          child: Center(
              child: Checkbox(
                  value: items[index]._isChecked,
                  onChanged: (val) {
                    setState(() {
                      items[index]._isChecked = val;
                      items[index]._isChecked
                          ? items[index].value =
                              double.parse(items[index].maxMark)
                          : items[index].value = 0;
                    });
                  })));
    } else {
      return Flexible(
          flex: 1,
          child: TextField(
            controller: items[index].tControl,
            //textAlign: TextAlign.center,
            onChanged: (text) {
              if (isNumeric(text)) {
                items[index].value = double.parse(text);
                print(text);
              } else {
                print("NOT ANUMBERRRR");
              }
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
              print("Back Arrow Clicked");
            },
          ),
        ),
        title: Text('Assessments'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {
              Navigator.push(context, homeRoute());
              print("Hamburger Menu Clicked");
            },
          )
        ],
      ),
      body: FutureBuilder<List<CriteriaDecode>>(
          future: fetchCriteria(),
          builder: (context, snapshot) {
            print('ffffffffffff');
            if(snapshot.hasData){
              print(snapshot.data[0].criteria[0].criteria);
              items = snapshot.data[0].criteria;

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    enabled: true,
                    isThreeLine: false,
                    title: new Card(
                        color: _accentColour,
                        child: Center(
                            child: Column(children: <Widget>[
                              Text('${items[index].criteria}'),
                              Text('${items[index].value}' +
                                  '/' +
                                  '${items[index].maxMark}'),
                              Row(children: <Widget>[
                                _buildTiles(index),
                              ]),
                            ]))),
                  );
                },
              );
            } else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());


          }),
    );
  }
}

Future<List<CriteriaDecode>> fetchCriteria() async {
  var response = await http.post('https://markit.mijdas.com/api/criteria/',
      body: jsonEncode({"request": "VIEW_CRITERIA", "assessment_id": "1"}));
  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return criteriaDecodeFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    // showDialog_1(_assessmentContext, "Error!", "Response Code: 404.\n\n\t\t\tNo Assessments Found.", "Close & Return");
    //navigate to an error page displaying lack of assessment error
    // return assessmentsFromJson(response.body);
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s) != null;
}

List<CriteriaDecode> criteriaDecodeFromJson(String str) =>
    List<CriteriaDecode>.from(
        json.decode(str).map((x) => CriteriaDecode.fromJson(x)));

String criteriaDecodeToJson(List<CriteriaDecode> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CriteriaDecode {
  List<Criterion> criteria;

  CriteriaDecode({
    this.criteria,
  });

  factory CriteriaDecode.fromJson(Map<String, dynamic> json) => CriteriaDecode(
        criteria: List<Criterion>.from(
            json["criteria"].map((x) => Criterion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "criteria": List<dynamic>.from(criteria.map((x) => x.toJson())),
      };
}

class Criterion {
  String criteria;
  String element;
  String maxMark;
  String displayText;
  bool _isChecked;
  TextEditingController tControl;
  double value = 0;

  Criterion({
    this.criteria,
    this.element,
    this.maxMark,
    this.displayText,
  }) {
    if (element == 1) {
      _isChecked = false;
    } else if (element == 2) {
      tControl = TextEditingController();
    }
  }

  factory Criterion.fromJson(Map<String, dynamic> json) => Criterion(
        criteria: json["criteria"],
        element: json["element"],
        maxMark: json["maxMark"],
        displayText: json["displayText"],
      );

  Map<String, dynamic> toJson() => {
        "criteria": criteria,
        "element": element,
        "maxMark": maxMark,
        "displayText": displayText,
      };
}
