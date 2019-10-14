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
//import 'CriteriaPage.dart';
import 'AssessmentPage.dart';
import 'signin.dart';
import 'HomePage.dart';

import '../Models/Student.dart';
import '../Models/StudentDecode.dart';

import '../Widgets/global_widgets.dart';

import '../Functions/fetches.dart';
import '../Functions/routes.dart';

//data handling/processing imports
import 'dart:async';

//import 'dart:convert';
//
//import 'package:http/http.dart' as http;

//Private variables
BuildContext _studentContext;
String _assessmentID;
String _selectedStudent;
List<Student> _studentList;
//List<String> _studentIDList;
//List<String> _recentSearchesList;

Future<List<StudentDecode>> _studentDecodeList;
List<Criterion> _criteriaList;

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
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.dehaze),
        //     onPressed: () {
        //       // Navigator.push(context, PageThree());
        //       // ScaffoldState.openEndDrawer();
        //       print("Hamburger Menu Clicked");
        //     },
        //   )
        // ],
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            // padding: EdgeInsets.all(10.0),
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
                  // print(snapshot.data[0].records[0].studentId);

                  _studentList = snapshot
                      .data[0].records; //studentList is the list of students
                 // List<TileObj> _parentListItems = new List<TileObj>();
                 // _studentIDList = new List<String>();

                  for (int i = 0; i < _studentList.length; i++) {
                    // print(_studentList[i].studentId);
                   // _studentIDList.add(_studentList[i].studentId);
                   // _parentListItems.add(new TileObj(
                    //    _studentList[i].studentId, _studentList[i].result));
                  }
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
                          // fontFamily: 'Karla',
                        ),
                      ),
                      // Text("Marking Progress"),
                      _studentsMarkedChart(),
                    ],
                  );
                  /*ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new PopulateTiles(
                          _parentListItems[index], context);
                    },
                    itemCount: _parentListItems.length,
                  );*/
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
    if (double.parse(s) >= 0)
      return _isMarked;
    else
      return Icon(Icons.error_outline);
  } catch (e) {
    return _isNotMarked; //trying to mark null produces error
  }
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

//int _getTotalCount() {
//  var count = 0;
//  try {
//    _studentList.forEach((x) {
//      count++;
//    });
//  } catch (e) {
//    return -1;
//  }
//  return count;
//}

Widget _searchArea(BuildContext context) {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue
  //final studentSearchController = TextEditingController();
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
                  /*_getMarkedCount().toString() +
                      "/" +
                      _getTotalCount().toString()),*/
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
                          // Color(0xFF0D47A1),
                          // Color(0xFF1976D2),
                          // Color(0xFF42A5F5),
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

              /*TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.drag_handle),
                    onPressed: () {
                      print("Filter Search Button Pressed");
                      String searchResults = showSearch(
                              context: context, delegate: StudentSearch())
                          .toString();
                      print(searchResults);
                    },
                  ),
                  hintStyle: new TextStyle(fontSize: 12),
                  labelStyle: new TextStyle(color: Colors.black),
                  hintText: "Enter A Username To Query...",
                  labelText: "Search Students",
                  border: OutlineInputBorder(),
                ),
                controller: studentSearchController,
              ),*/
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
  //hardcoded searched items
  // final recentSearches = [
  //   "ab123",
  //   "cd456",
  //   "ef789",
  //   "gh000",
  //   "alice",
  // ];



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
        child: Text("Please Select A Student From The Autofill Options."));
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
                  _getStudent(suggestedItems[index].studentId).result)),
          child: ListTile(
            onTap: () {
              print(suggestedItems[index].studentId);
              print(_getIndexForStudent(suggestedItems[index].studentId));
              _selectedStudent = suggestedItems[index].studentId;
              Navigator.push(
                  context,
                  criteriaRoute(
                      _studentList[_getIndexForStudent(
                          suggestedItems[index].studentId)],
                      _assessmentID,
                      _criteriaList)); //Pass in a bool for isMarked to load the old marks
              // close(context, route);
            },
            leading: _getMarkedState(
                _getStudent(suggestedItems[index].studentId).result),
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

//class TileObj {
//  String title;
//  String tileResult;
//
//  TileObj(this.title, this.tileResult);
//}

//class PopulateTiles extends StatelessWidget {
//
//
//  final TileObj fTile;
//  BuildContext contextT;
//  PopulateTiles(this.fTile, [this.contextT]);
//
//  @override
//  Widget build(BuildContext context) {
//    //return _buildList(fTile);
//  }
//
////widget to load tile list
////  Widget _buildList(TileObj t) {
////    Color _accentColour = Color(0xffBFD4DF);
////    return new ListTile(
////        dense: true,
////        enabled: true,
////        isThreeLine: false,
////        onLongPress: () => print("Long Press: [" + t.title + "]."),
////        onTap: () {
////          // Navigator.push(contextT, criteriaRoute(t.tileID));
////          print("Tap: [" + t.title + "].");
////        },
////        // subtitle: new Text("Subtitle"),
////        // leading: new Text("Leading"),
////        selected: true,
////        // trailing: new Text("Trailing"),
////        title: new Card(
////          color: _accentColour,
////          child: Column(
////            children: <Widget>[
////              Container(
////                height: 85.0,
////                alignment: Alignment(0.0, 0.0),
////                child: Text(t.title),
////              )
////            ],
////          ),
////        ));
////  }
//}

//class structure for each tile object
