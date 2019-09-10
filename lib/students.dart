import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

//local imports
import './criteria_manager.dart';
import './assessment.dart';
import './main.dart';
import './home.dart';
import './global_widgets.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

//Private variables
BuildContext _studentContext;
String _assessmentID;
List<Student> _studentList;
List<String> _studentIDList;
List<String> _recentSearchesList;
bool _isFetchDone;
Icon _isMarked = new Icon(
  Icons.check_box,
  color: Colors.green,
);
Icon _isNotMarked = new Icon(
  Icons.check_box_outline_blank,
);

Route studentsRoute(String id) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Students(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      _studentContext = context; //assigning page context
      _assessmentID = id; //assigning page ID
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class Students extends StatelessWidget {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {
              // Navigator.push(context, PageThree());
              print("Hamburger Menu Clicked");
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                ListTile(
                  title: Text("Go To First Screen"),
                  onTap: () {
                    print("First Clicked");
                  },
                ),
                ListTile(
                  title: Text("Go To Second Screen"),
                  onTap: () {
                    print("Second Clicked");
                  },
                ),
              ],
            ),
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
              future: fetchStudents(_assessmentID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data[0].records[0].studentId);
                  _studentList = snapshot
                      .data[0].records; //studentList is the list of students
                  List<TileObj> _parentListItems = new List<TileObj>();
                  _studentIDList = new List<String>();

                  for (int i = 0; i < _studentList.length; i++) {
                    // print(_studentList[i].studentId);
                    _studentIDList.add(_studentList[i].studentId);
                    _parentListItems.add(new TileObj(
                        _studentList[i].studentId, _studentList[i].result));
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
                                          _studentIDList.length.toString() +
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
      /*Center(
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: StudentSearch());
          },
        ),
      ),*/
      /*bottomNavigationBar: BottomAppBar(
        child: Container(
            height: 70.0,
            child: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                print("Bottom AppBar Pressed");
                // fetchedData.forEach((key, val) => print('Key: $key, Value: $val'));
                // print(searchedUser);
                // getData(searchedUser);
                // getData();
              },
            )),
        color: Theme.of(context).primaryColor,
      ),*/
    );
  }
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
  return _studentIDList.indexWhere((x) => x.startsWith(s));
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

int _getTotalCount() {
  var count = 0;
  try {
    _studentList.forEach((x) {
      count++;
    });
  } catch (e) {
    return -1;
  }
  return count;
}

Widget _searchArea(BuildContext context) {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue
  final studentSearchController = TextEditingController();
  _isFetchDone = false;

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500, //415 for width of pixel
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
                  text: (getSubjecttName() + " - " + getAssessmentName()),
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
  dataMap.putIfAbsent("Unmarked", () => (_studentIDList.length - markedCount));
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

class StudentSearch extends SearchDelegate<String> {
  //hardcoded searched items
  // final studentsList = [
  //   "this",
  //   "is",
  //   "a",
  //   "list",
  //   "of",
  //   "hardcoded",
  //   "students",
  //   "ab123",
  //   "cd456",
  //   "ef789",
  //   "gh000",
  // ];
  // final recentSearches = [
  //   "ab123",
  //   "cd456",
  //   "ef789",
  //   "gh000",
  //   "alice",
  // ];

  final studentsList = _studentIDList;
  // final recentSearches = _recentSearchesList;

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
        ? studentsList
        : studentsList.where((x) => x.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(color: _getMarkedStateBar(_getStudent(suggestedItems[index].toString()).result)),
        child: ListTile(
          onTap: () {
            print(suggestedItems[index].toString());
            print(_getIndexForStudent(suggestedItems[index].toString()));
            Navigator.push(context,
                PageThree()); //JOEL USE THIS TO NAVIGATE TO SELECTED STUDENTS CRITERIA!
            // close(context, route);
          },
          leading: _getMarkedState(
              _getStudent(suggestedItems[index].toString()).result),
          trailing: RichText(
            text: TextSpan(
                text: _getStudent(suggestedItems[index].toString()).result,
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
                text: suggestedItems[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestedItems[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]),
          ),
        ),
      ),
      itemCount: suggestedItems.length,
    );
  }
}

class PopulateTiles extends StatelessWidget {
  Color _accentColour = Color(0xffBFD4DF);

  final TileObj fTile;
  BuildContext contextT;
  PopulateTiles(this.fTile, [this.contextT]);

  @override
  Widget build(BuildContext context) {
    return _buildList(fTile);
  }

//widget to load tile list
  Widget _buildList(TileObj t) {
    return new ListTile(
        dense: true,
        enabled: true,
        isThreeLine: false,
        onLongPress: () => print("Long Press: [" + t.title + "]."),
        onTap: () {
          // Navigator.push(contextT, criteriaRoute(t.tileID));
          print("Tap: [" + t.title + "].");
        },
        // subtitle: new Text("Subtitle"),
        // leading: new Text("Leading"),
        selected: true,
        // trailing: new Text("Trailing"),
        title: new Card(
          color: _accentColour,
          child: Column(
            children: <Widget>[
              Container(
                height: 85.0,
                alignment: Alignment(0.0, 0.0),
                child: Text(t.title),
              )
            ],
          ),
        ));
  }
}

//class structure for each tile object
class TileObj {
  String title;
  String tileResult;
  TileObj(this.title, this.tileResult);
}

Future<List<StudentDecode>> fetchStudents(String s) async {
  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({"request": "POPULATE_STUDENTS", "assessment_id": s}));

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return studentDecodeFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    showDialog_1(_studentContext, "Error!",
        "Response Code: 404.\n\n\t\t\tNo Students Found.", "Close & Return");
    //navigate to an error page displaying lack of assessment error
    // return studentDecodeFromJson(response.body);
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

List<StudentDecode> studentDecodeFromJson(String str) =>
    new List<StudentDecode>.from(
        json.decode(str).map((x) => StudentDecode.fromJson(x)));

class StudentDecode {
  List<Student> records;

  StudentDecode({
    this.records,
  });

  factory StudentDecode.fromJson(Map<String, dynamic> json) =>
      new StudentDecode(
        records: new List<Student>.from(
            json["records"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": new List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Student {
  String studentId;
  String result;

  Student({
    this.studentId,
    this.result,
  });

  factory Student.fromJson(Map<String, dynamic> json) => new Student(
        studentId: json["student_id"],
        // result: json["result"],
        result: json["result"] == null ? null : json["result"],
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        // "result": result,
        "result": result == null ? null : result,
      };
}
