/*
TODO----------
-add slider incerements --Done(-Mitch)
-fix http --?(-Mitch)
-add submit button --Done(-Mitch)

 */

//Got lost trying to figure multi pages out - will need it explained after/before meeting pls xoxo - this code is ready for posts - joel
import 'package:flutter/material.dart';

//local imports
import './home.dart';
import './students.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Student _selectedStudent;
// Color _buttonColour = new Color(0xff0069C0);
Color _activeColour = new Color(0xff0069C0);
Color _inactiveColour = new Color(0xffA0C8E3);
List<Criterion> _assCrit;
bool
    _isFetchDone; //boolean check to see if API request is finished before populating certain fields

Route CriteriaRoute(Student s, String assID, List<Criterion> crit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CriteriaPageState(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      _selectedStudent = s; //assigning page ID

      _assCrit = crit;

      print(_selectedStudent.studentId);
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

  CriteriaPage() {
    items = _assCrit;
  }

  /*
    element cheat sheet: (Element ID - Object Type)
    
    0 - Checkbox
    1 - Slider
    2 - Textfield
  
  */
  Widget _buildTiles(int index) {
    if (items[index].element == "0") {
      return Flexible(
          flex: 1,
          child: Center(
              child: Checkbox(
                  value: items[index]._isChecked,
                  activeColor: _activeColour,
                  onChanged: (val) {
                    setState(() {
                      items[index]._isChecked = val;
                      items[index]._isChecked
                          ? items[index].value = items[index].maxMarkI
                          : items[index].value = 0;
                    });
                  })));
    } else if (items[index].element == "1") {
      //items[index].value = 0;
      return Flexible(
          flex: 1,
          child: SliderTheme(
            data: SliderThemeData(
              //for concealing track ticks lol
              thumbColor: _activeColour,
              activeTrackColor: _activeColour,
              activeTickMarkColor: _activeColour,
              inactiveTrackColor: _inactiveColour,
              inactiveTickMarkColor: _inactiveColour,
              overlayColor: _activeColour.withAlpha(32),
            ),
            child: Slider(
              min: 0.0,
              max: items[index].maxMarkI,
              divisions: items[index].maxMarkI.toInt() *
                  4, //creates increments of 0.25
              onChanged: (newSliderValue) {
                setState(() {
                  items[index].value = newSliderValue;
                  // items[index].value = double.parse(newSliderValue.toStringAsPrecision(3));
                  // items[index].value = newSliderValue.roundToDouble();
                });
              },
              value: items[index].value,
            ),
          ));
    } else {
      return Flexible(
          flex: 1,
          child: TextField(
            controller: items[index].tControl,
            // textAlign: TextAlign.center, //what a stupid bug this is
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
          title: Text('Marking'),
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
        body: Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                width: 500,
                height: 50,
                child: _markingTitleArea(),
              ),
              Flexible(
                  flex: 10,
                  child: ListView.builder(
                      itemCount: (items.length),
                      itemBuilder: (context, index) {
                        //adding code for interactive text results btw Joel
                        String criteriaValueText;

                        if (items[index].maxMark == null)
                          criteriaValueText = "";
                        else
                          criteriaValueText = '${items[index].value}' +
                              '/' +
                              '${items[index].maxMark}';

                        return ListTile(
                          dense: true,
                          enabled: true,
                          isThreeLine: false,
                          title: new Card(
                              //MAKE BUILD CARDS
                              color: _accentColour,
                              child: Center(
                                  child: Column(children: <Widget>[
                                Text(
                                  '${items[index].displayText}',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  criteriaValueText,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                Row(children: <Widget>[
                                  _buildTiles(index),
                                ]),
                              ]))),
                        );
                      })),
              //   new Container(height: 20, alignment:Alignment.bottomLeft,child: Text('Comments:')),//MAYBE CHANGE THIS TO A labelText???????
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 175.0,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      child: new Scrollbar(
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  //hintText: "Comments",
                                  labelText: "Comments",
                                  fillColor: Colors.white70,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(20.0),
                                ),
                              ))))),
              Container(
                width: 500,
                height: 70,
                child: _markingFooterArea(),
              ),
            ]));
  }
}

Widget _markingTitleArea() {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue
  // _isFetchDone = false;
  _mainBackdrop = isMarkedCol(getStudent());

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500, //415 for width of pixel
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(color: _mainBackdrop),
            Positioned(
              top: 15,
              left: 30,
              width: 330,
              height: 30,
              child: RichText(
                text: TextSpan(
                    text: ("Username:    "),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: getStudent(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 5,
        left: 330,
        width: 80,
        height: 40,
        child: Text(""),
      ),
    ],
  );
}

Widget _markingFooterArea() {
  Color _mainBackdrop = new Color(0xffE1E2E1); //canvas colour
  // Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue
  // _isFetchDone = false;

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500, //415 for width of pixel
        height: 70,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(color: _mainBackdrop),
            Positioned(
              top: 5,
              left: 60,
              width: 150,
              height: 30,
              child: RichText(
                text: TextSpan(
                  text: ("Marks:"),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 25,
        left: 80,
        width: 120, //should run to about the middle
        height: 40,
        child: RichText(
          text: TextSpan(
              text: (getTotalGivenMark().toString()),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: ("/" + getMaximumMark().toString()),
                    style: TextStyle(
                        color: Colors.grey[700], fontWeight: FontWeight.w600))
              ]),
        ),
      ),
      Positioned(
        top: 0,
        left: 210,
        width: 170,
        height: 60,
        child: Container(
          child: ButtonTheme(
            minWidth: 170.0,
            height: 60.0,
            child: RaisedButton(
              onPressed: () {
                print("Submit Button pressed.");
              },
              child: RichText(
                text: TextSpan(
                  text: ("Submit"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              color: _activeColour,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(7.0)),
              textColor: Colors.white,
            ),
          ),
        ),

        /*RichText(
          text: TextSpan(
            text: ("7.5/10"),
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),*/
      ),
    ],
  );
}

// void setFetchDone(bool b) {
//   _isFetchDone = b;
// }

double getMaximumMark() {
  var max = 0.00;
  try {
    _assCrit.forEach((x) {
      if (x.maxMark != null) max += x.maxMarkI;
    });
  } catch (e) {
    return -1;
  }
  return max;
}

double getTotalGivenMark() {
  var count = 0.00;
  try {
    _assCrit.forEach((x) {
      if (x.value != null) count += x.value;
    });
  } catch (e) {
    return -1;
  }
  return count;
}

Future<List<CriteriaDecode>> fetchCriteria(String i) async {
  var response = await http.post('https://markit.mijdas.com/api/criteria/',
      body: jsonEncode({"request": "VIEW_CRITERIA", "assessment_id": i}));
  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);

    List<CriteriaDecode> rValue = criteriaDecodeFromJson(response.body);
    _isFetchDone = true;
    return rValue;
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
            json["records"].map((x) => Criterion.fromJson(x))),
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
      _isChecked = false;
    } else if (element == "2") {
      tControl = TextEditingController();
    }
    this.iD = int.parse(criteria);
    this.elementType = int.parse(element);
    if (maxMark == null)
      this.maxMarkI =
          -1.0; //temp fix, although can be used to identify null boxes in future
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

  factory Criterion.fromJson(Map<String, dynamic> json) => Criterion(
        criteria: json["criteria"],
        element: json["element"],
        maxMark: json["maxMark"] == null ? null : json["maxMark"],
        displayText: json["displayText"],
      );

  Map<String, dynamic> toJson() => {
        "criteria": criteria,
        "element": element,
        "maxMark": maxMark == null ? null : maxMark,
        "displayText": displayText,
      };
}
