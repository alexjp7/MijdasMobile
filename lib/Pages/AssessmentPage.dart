//can we rewrite populatetiles so that it takes in an assessment rather than another thing

import 'package:flutter/material.dart';

//local imports
import 'signin.dart';
import 'StudentsPage.dart';
import '../Widgets/global_widgets.dart';

//models
import '../Models/Assessment.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

BuildContext _assessmentContext;
String _assessmentID;
String _assessmentName;
String _assessmentMaxMark;
Future<List<Assessment>> _assessmentList;

Route assessmentRoute(String s) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AssessmentPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      _assessmentContext = context; //assigning page buildcontext
      _assessmentID = s; //assigning page ID
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class AssessmentPage extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  @override
  void initState() {
    super.initState();
    _assessmentList = fetchAssessments(_assessmentID);
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
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            // padding: EdgeInsets.all(10.0),
            children: <Widget>[
              settingsHeader(context, getUsername()),
              settingsTile(Icons.person, "Profile", () {
                print("Profile Clicked.");
              }),
              settingsTile(Icons.person, "Announcements", () {
                print("Announcements Clicked.");
              }),
              settingsTile(Icons.person, "Calendar", () {
                print("Calendar Clicked.");
              }),
              settingsTile(Icons.person, "Job Board", () {
                print("Job Board Clicked.");
              }),
              settingsTile(Icons.person, "Settings", () {
                print("Settings Clicked.");
              }),
              settingsTile(Icons.person, "Sign Out", () {
                print("Sign Out Clicked.");
              }),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Assessment>>(
        future: _assessmentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TileObj> _parentListItems = new List<TileObj>();

            for (int i = 0; i < snapshot.data.length; i++) {
              _parentListItems.add(new TileObj(
                  snapshot.data[i].name,
                  snapshot.data[i].id,
                  snapshot.data[i].a_number,
                  snapshot.data[i].isActive,
                  snapshot.data[i].maxMark));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _buildList(_parentListItems[index]);
              },
              itemCount: _parentListItems.length,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator()); //LOADING CIRCLE
        },
      ),
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

  Widget _buildList(TileObj t) {
    Color _accentColour = Color(0xffBFD4DF);
    // if (t.children.isEmpty)

    if (t.isActive == "0") {
      _accentColour = Color(0x11000000);
    }

    return new ListTile(
        dense: true,
        enabled: true,
        isThreeLine: false,
        onLongPress: () async {
          print("Long Press: [" +
              t.title +
              "]. UserPriv: [" +
              getPriv().toString() +
              "].");
          if (getPriv() == 2) {
            //_assessmentList=null;
            await onHoldSettings_Assessments(_assessmentContext, t.title, t.tileID);//pass assessment here once rewritten
            setState(() {

            });

          }
        },
        onTap: () {
          _assessmentName = t.title;
          _assessmentMaxMark = t.tileMaxMark;
          Navigator.push(context, studentsRoute(t.tileID));
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
//    // title: new Text(t.title));
//
//    // return new ExpansionTile(
//    //   key: new PageStorageKey<int>(3),
//    //   title: new Text(t.title),
//    //   // title: new Text(t.title, style: TextStyle(color: Colors.black),),
//    //   children: t.children.map(_buildList).toList(),
//    // );
  }
}

//class PopulateTiles extends StatelessWidget {
//  Color _accentColour = Color(0xffBFD4DF);
//
//  final TileObj fTile;
//  BuildContext contextT;
//  PopulateTiles(this.fTile, [this.contextT]);
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return _buildList(fTile);
//  }
//
////widget to load tile list
//  Widget _buildList(TileObj t) {
//    // if (t.children.isEmpty)
//
//    if(t.isActive=="0"){
//      _accentColour = Color(0x11000000);
//    }
//
//    return new ListTile(
//        dense: true,
//        enabled: true,
//        isThreeLine: false,
//        onLongPress: () async {
//            print("Long Press: [" + t.title + "]. UserPriv: ["+getPriv().toString()+"].");
//            if(getPriv() == 2) {
//              _assessmentList=null;
//             await onHoldSettings_Assessments(_assessmentContext, t.title,t.tileID);//pass assessment here once rewritten
//              //refreshAssList();
//            }
//
//
//          },
//        onTap: () {
//          _assessmentName = t.title;
//          _assessmentMaxMark = t.tileMaxMark;
//          Navigator.push(contextT, studentsRoute(t.tileID));
//        },
//        // subtitle: new Text("Subtitle"),
//        // leading: new Text("Leading"),
//        selected: true,
//        // trailing: new Text("Trailing"),
//        title: new Card(
//          color: _accentColour,
//          child: Column(
//            children: <Widget>[
//              Container(
//                height: 85.0,
//                alignment: Alignment(0.0, 0.0),
//                child: Text(t.title),
//              )
//            ],
//          ),
//        ));
//    // title: new Text(t.title));
//
//    // return new ExpansionTile(
//    //   key: new PageStorageKey<int>(3),
//    //   title: new Text(t.title),
//    //   // title: new Text(t.title, style: TextStyle(color: Colors.black),),
//    //   children: t.children.map(_buildList).toList(),
//    // );
//  }
//}

//class structure for each tile object
class TileObj {
  String title;
  String tileID;
  String tileANum;
  String isActive;
  String tileMaxMark;

  TileObj(
      this.title, this.tileID, this.tileANum, this.isActive, this.tileMaxMark);
}

Future<List<Assessment>> fetchAssessments(String s) async {
  var response = await http.post('https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({
        "request": "VIEW_ASSESSMENT",
        "subject_id": s,
        "is_coordinator": (getPriv() == 2)
      }));

  if (response.statusCode == 200) {
//    print('response code:  200\n');
    print('response body: ' + response.body);
    return assessmentsFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    showDialog_1(
        _assessmentContext,
        "Error!",
        "Response Code: 404.\n\n\t\t\tNo Assessments Found.",
        "Close & Return",
        false);
    //navigate to an error page displaying lack of assessment error
    // return assessmentsFromJson(response.body);
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

List<Assessment> assessmentsFromJson(String str) => new List<Assessment>.from(
    json.decode(str)["records"].map((x) => Assessment.fromJson(x)));

String getAssessmentName() {
  return _assessmentName;
}

String getAssessmentMaxMark() {
  return _assessmentMaxMark;
}

Future<bool> refreshAssList() async {
  //_assessmentList = null;
  print("REFRESHING");
  //DO SOMETHING HERE
  await(_assessmentList = fetchAssessments(_assessmentID));
  print("REFRESHED");
  return(true);
}