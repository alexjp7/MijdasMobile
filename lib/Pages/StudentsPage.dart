/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import 'package:flutter/material.dart';

import '../Models/QueryManager.dart';
import '../Models/Criterion.dart';

import 'package:pie_chart/pie_chart.dart';

//local imports
import 'AssessmentPage.dart';
import 'SignInPage.dart';
import 'HomePage.dart';

import '../Models/Student.dart';
import '../Models/StudentDecode.dart';

import '../Widgets/global_widgets.dart';

import '../Functions/fetches.dart';
import '../Functions/routes.dart';

//data handling/processing imports
import 'dart:async';

//Private variables
BuildContext _studentContext;
String _assessmentID;
String _selectedStudent;
List<Student> _studentList;

Future<List<StudentDecode>> _studentDecodeList;


bool _isFetchDone;

Icon _isMarked = new Icon(
  Icons.check_box,
  color: Colors.green,
);
Icon _isNotMarked = new Icon(
  Icons.check_box_outline_blank,
);

class StudentsPage extends StatefulWidget {
  StudentsPage(context, id) {
    _studentContext = context; //assigning page context
    _assessmentID = id;
  }

  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  void initState() {
    super.initState();
    _studentDecodeList = fetchStudents(_assessmentID, _studentContext);
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
        title: Text('Students'),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            children: sideBar(context, getUsername()),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 500,
            height: 100,
            child: _searchArea(context),
          ),
          Container(
            width: 500,
            height: 503,
            child: FutureBuilder<List<StudentDecode>>(
              future: _studentDecodeList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _studentList = snapshot.data[0].records;
                  _isFetchDone = true; //able to click button now
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                            text: "Marking Progress:\n",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: ("(" + _getMarkedCount().toString()),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0),
                                  children: [
                                    TextSpan(
                                      text: (" / " +
                                          _studentList.length.toString() +
                                          ")"),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ]),
                            ]),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      // Text("Marking Progress"),
                      _studentsMarkedChart(),
                      // Text(_studentList[0].criteria[0].comment),
                    ],
                  );
                } else if (snapshot.hasError) {
                  _isFetchDone = false;
                  return Text("${snapshot.error}");
                }
                return Center(
                    child: CircularProgressIndicator()); //LOADING CIRCLE
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshStudentsList() async {
    print("Refreshing Students");

    await (_studentDecodeList = fetchStudents(_assessmentID, _studentContext));
    setState(() {});
    return;

    //REFRESH SEARCHED LIST HERE
  }
}

Future<void> refreshStudentsList() async {
  print("Refreshing Students");
  await (_studentDecodeList = fetchStudents(_assessmentID, _studentContext));
  return;
}

void makeSearch(context){
  showSearch(context: context, delegate: StudentSearch());
  return;
}

Icon _getMarkedState(String s) {
  try {
    if (s != null)
      return _isMarked;
    else
      return _isNotMarked;
  } catch (e) {
    return Icon(Icons.error_outline); //trying to mark null produces error
  }
  
  // try {
  //   if (double.parse(s) >= 0)
  //     return _isMarked;
  //   else
  //     return Icon(Icons.error_outline);
  // } catch (e) {
  //   return _isNotMarked; //trying to mark null produces error
  // }
}

Color _getMarkedStateBar(String s) {
  try {
    if (double.parse(s) >= 0)
      return Colors.black12;
    else
      return Colors.red;
  } catch (e) {
    return Colors.transparent; //trying to mark null produces error
  }
}

Student _getStudent(String s) {
  return _studentList.firstWhere((x) => x.studentId.startsWith(s));
}

int _getIndexForStudent(String s) {
  return _studentList.indexWhere((x) => x.studentId.startsWith(s));
}

int _getMarkedCount() {
  var count = 0;
  try {
    _studentList.forEach((x) {
      if (x.result != null) count++;
    });
  } catch (e) {
    return -1;
  }
  return count;
}



Widget _searchArea(BuildContext context) {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  _isFetchDone = false;

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500,
        //415 for width of pixel
        height: 100,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(color: _mainBackdrop),
            Positioned(
              top: 65,
              left: 70,
              width: 330,
              height: 40,
              child: RichText(
                text: TextSpan(
                  text: (getSubjectName() + " - " + getAssessmentName()),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            Positioned(
              top: 65,
              left: 335,
              width: 80,
              height: 40,
              child: RichText(
                text: TextSpan(
                  text: (""),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 50,
              width: 311,
              height: 45,
              child: RaisedButton(
                onPressed: () {
                  if (_isFetchDone) {
                    //check if api fetch is done
                    print("Filter Search Button Pressed");
                    String searchResults =
                        showSearch(context: context, delegate: StudentSearch())
                            .toString();
                    print(searchResults);
                  } else {
                    print(
                        "API Fetch Incomplete. Please Wait."); //simple print msg, no prompt cuz annoying for user
                  }
                },
                textColor: Colors.black,
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff2C96EA),
                          Color(0xffA2C8EF),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(80.0))),
                  padding: const EdgeInsets.fromLTRB(65, 10, 20, 10),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        Text('\tSearch Students',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _studentsMarkedChart() {
  double markedCount = _getMarkedCount().toDouble();
  Map<String, double> dataMap = new Map();
  dataMap.putIfAbsent("Unmarked", () => (_studentList.length - markedCount));
  dataMap.putIfAbsent("Marked", () => markedCount);

  return Padding(
    padding: EdgeInsets.all(32.0),
    child: SizedBox(
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          legendFontColor: Colors.blueGrey[900],
          legendFontSize: 14.0,
          legendFontWeight: FontWeight.w500,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32.0,
          chartRadius: MediaQuery.of(_studentContext).size.width / 2.7,
          showChartValuesInPercentage: true,
          showChartValues: true,
          chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
        )),
  );
}

String getStudent() {
  return _selectedStudent;
}

Color isMarkedCol(String s) {
  try {
    if (double.parse(_getStudent(s).result) >= 0)
      return Colors.green[200];
    else
      return Colors.redAccent[100];
  } catch (e) {
    return Color(0xff54b3ff); //trying to mark null produces error
  }
}

class StudentSearch extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some results based on the selection
    return Center(
        child: Text("Please Select A Student From The Autofill Options.")
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    final suggestedItems = query.isEmpty
        ? _studentList
        : _studentList.where((x) => x.studentId.startsWith(query)).toList();

    return RefreshIndicator(
      onRefresh: refreshStudentsList,
      child: ListView.builder(
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
              color: _getMarkedStateBar(
                  _getStudent(suggestedItems[index].studentId).criteria[1].result)),
                  // _getMarkedStateBar(
                  // _getStudent(suggestedItems[index].studentId).result)),
          child: ListTile(
            onTap: () {
              print(suggestedItems[index].studentId);
              print(_getIndexForStudent(suggestedItems[index].studentId));
              //print(_criteriaList[0].criteria);
              _selectedStudent = suggestedItems[index].studentId;

              Navigator.push(context,criteriaRoute(_studentList[_getIndexForStudent(suggestedItems[index].studentId)],_assessmentID,QueryManager().criteriaList[0].criteria, _studentList[_getIndexForStudent(suggestedItems[index].studentId)].criteria)); //Pass in a bool for isMarked to load the old marks
            },
            leading: _getMarkedState(
                _getStudent(suggestedItems[index].studentId).criteria[1].result),
                // _getMarkedState(
                // _getStudent(suggestedItems[index].studentId).result),
            trailing: RichText(
              text: TextSpan(
                  text: _getStudent(suggestedItems[index].studentId).result,
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: (" /" + getAssessmentMaxMark()),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
            title: RichText(
              text: TextSpan(
                  text: suggestedItems[index].studentId.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestedItems[index].studentId.substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
          ),
        ),
        itemCount: suggestedItems.length,
      ),
    );
  }
}