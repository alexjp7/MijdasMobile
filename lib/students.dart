import 'package:flutter/material.dart';

//local imports
import './criteria_manager.dart';
import './assessment.dart';
import './main.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String assessmentID;

Route studentsRoute(String s) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Students(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      assessmentID = s; //assigning page ID
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
            height: 100,
            child: FutureBuilder<List<StudentDecode>>(
              future: fetchStudents(assessmentID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data[0].records[0].studentId);
                  List<Record> studentList = snapshot.data[0].records;//studentList is the list of students


                  List<TileObj> _parentListItems = new List<TileObj>();

                  for (Record record in studentList) {
                    print(record.studentId);
                    if(record.studentId == null){
                      if(record.result == null)
                        _parentListItems.add(new TileObj("NULL BOTH", "NULL BOTH"));
                      else 
                        _parentListItems.add(new TileObj("NULL ID", record.result));
                    } else if(record.result == null){
                      if(record.studentId == null)
                        _parentListItems.add(new TileObj("NULL BOTH", "NULL BOTH"));
                      else 
                        _parentListItems.add(new TileObj(record.studentId, "NULL RESULT"));
                    } else if (record.studentId == null && record.result == null){
                      _parentListItems.add(new TileObj(record.studentId, record.result));
                    }
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new PopulateTiles(
                          _parentListItems[index], context);
                    },
                    itemCount: _parentListItems.length,
                  );
                } else if (snapshot.hasError) {
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
      bottomNavigationBar: BottomAppBar(
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
      ),
    );
  }
}

Widget _searchArea(BuildContext context) {
  Color _mainBackdrop = new Color(0xff2196F3); //light blue
  final studentSearchController = TextEditingController();

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
              left: 50,
              width: 275,
              height: 40,
              child: RichText(
                text: TextSpan(
                  text: "Subject 1 - Assignment 1",
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
                  text: "126/500",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 50,
              width: 311,
              height: 45,
              child: TextField(
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
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             showSearch(context: context, delegate: StudentSearch());
//           },
//         ),

class StudentSearch extends SearchDelegate<String> {
  //hardcoded searched items
  final studentsList = [
    "this",
    "is",
    "a",
    "list",
    "of",
    "hardcoded",
    "students",
    "ab123",
    "cd456",
    "ef789",
    "gh000",
  ];
  final recentSearches = [
    "ab123",
    "cd456",
    "ef789",
    "gh000",
  ];

  IconData markingState(int i) {
    if (i == 1)
      return Icons.check_box;
    else if (i == 2)
      return Icons.indeterminate_check_box;
    else
      return Icons.check_box_outline_blank;
  }

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
    return Text(query);
    /*Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          color: Colors.red,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );*/
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    final suggestedItems = query.isEmpty
        ? recentSearches
        : studentsList.where((x) => x.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
          close(context, null);
          // print(suggestedItems[index].toString());
          Navigator.push(context, PageThree());
          // close(context, route);
        },
        leading: Icon(markingState(index)),
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
      body: jsonEncode(
          {"request": "POPULATE_STUDENTS", "assessment_id": s}));

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return studentDecodeFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    //navigate to an error page displaying lack of assessment error
    return studentDecodeFromJson(response.body);
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

List<StudentDecode> studentDecodeFromJson(String str) => new List<StudentDecode>.from(json.decode(str).map((x) => StudentDecode.fromJson(x)));


class StudentDecode {
  List<Record> records;

  StudentDecode({
    this.records,
  });

  factory StudentDecode.fromJson(Map<String, dynamic> json) => new StudentDecode(
    records: new List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": new List<dynamic>.from(records.map((x) => x.toJson())),
  };
}

class Record {
  String studentId;
  String result;

  Record({
    this.studentId,
    this.result,
  });

  factory Record.fromJson(Map<String, dynamic> json) => new Record(
    studentId: json["student_id"],
    result: json["result"] == null ? null : json["result"],
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    "result": result == null ? null : result,
  };
}
