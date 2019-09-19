import 'package:flutter/material.dart';
import 'package:mijdas_app/QueryManager.dart';

//local imports
import '../main.dart';
import 'signin.dart';
import 'AssessmentPage.dart';
import '../Widgets/global_widgets.dart';
// import './criteria_manager.dart';



//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String _subjectName;
BuildContext _homeContext;

Route homeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Home(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      _homeContext = context; //assigning buildcontext
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

// //base url as string
// final String jsonURL = "https://markit.mijdas.com/api/requests/subject/read.php?username=";
// //for storing json results globally
// Map<String, dynamic> fetchedData;

//uninitiated global context variable for use later
// BuildContext homepageContext;
// String chosenAssessmentID;

class Home extends StatelessWidget {
  // Future<String> getData(String s) async {
  //   var response = await http.get(
  //     Uri.encodeFull(jsonURL+s),
  //     headers: {
  //       "Accept": "application/json"
  //     }
  //   );

  //   // Map<String, dynamic> fetchedData = json.decode(response.body);
  //   fetchedData = json.decode(response.body);
  //   print(fetchedData);
  // }

  List<Universities> universitiesList;

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
        title: Text('Home'),
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
      body: FutureBuilder<List<Universities>>(
        future: fetchUniversities(getUsername()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            universitiesList = snapshot.data;

            //QueryManager().universityList=snapshot.data;

            List<TileObj> _parentListItems = new List<TileObj>();

            for (int i = 0; i < snapshot.data.length; i++) {
              List<TileObj> _childrenListItems = new List<TileObj>();
              for (int i2 = 0; i2 < snapshot.data[i].subjects.length; i2++) {
                _childrenListItems.add(new TileObj.subject(
                    snapshot.data[i].subjects[i2].subjectCode,
                    universitiesList[i].subjects[i2].id));
              }
              _parentListItems.add(new TileObj(
                  snapshot.data[i].institution, _childrenListItems));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                // homepageContext = context; //pass and store the page context globally instead of carrying it with each tile.
                return new PopulateTiles(_parentListItems[index]);
              },
              itemCount: _parentListItems.length,
            );

            //Maybe leave this here for future reference(-Mitch):

            //Text('${snapshot.data[0].institution}');
            //MITCH LOOK HERE I DONT KNOW HOW TO FORMAT IT SORRY. i didnt delete your old stuff but my brain is in post mode
            //snapshot.data[].institution = uni name,
            //snapshot.data[].subjects[].subjectCode=subjectCode
            //snapshot.data[].subjects[].id=subject id

          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator()); //LOADING CIRCLE
        },
      ),
      /*

        Maybe leave this here too for reference, we can clean it all up at the end?

      LEGACY CODE WITH LISTVIEWBUILDER
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new PopulateTiles(_resultsList[index]);
        },
        itemCount: _resultsList.length,
      ),
      */

      // ListView(
      //     physics: const AlwaysScrollableScrollPhysics(),
      //     padding: const EdgeInsets.all(8.0),
      //     children: <Widget>[

      //     ]),
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

class PopulateTiles extends StatelessWidget {
  Color _accentColour = Color(0xffBFD4DF);

  final TileObj fTile;
  // BuildContext contextT;
  PopulateTiles(this.fTile);

  @override
  Widget build(BuildContext context) {
    return _buildList(fTile);
  }

//widget to load tile list
  Widget _buildList(TileObj t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () {
            print("Long Press: [" +
                t.title +
                "]. UserPriv: [" +
                getPriv().toString() +
                "].");
            if (getPriv() == 2) onHoldSettings_HomeTile(_homeContext, t.title,t.tileID);
          },
          onTap: () {
            _subjectName = t.title;
            Navigator.push(_homeContext, assessmentRoute(t.tileID));
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
    // title: new Text(t.title));

    return new GestureDetector(
      onLongPress: () {
        print("Long Press: [" +
            t.title +
            "]. UserPriv: [" +
            getPriv().toString() +
            "].");
        if (getPriv() == 2) onHoldSettings_HomeHead(_homeContext, t.title);
      },
      child: ExpansionTile(
        key: new PageStorageKey<int>(3),
        title: /*Container(
        child: */
            Text(
          t.title /*, style: TextStyle(color: Colors.green)*/,
        ),
        // alignment: Alignment.center,
        // ),
        // trailing: Text(""),
        children: t.children.map(_buildList).toList(),
      ),
    );
  }
}

//class structure for each tile object
class TileObj {
  String title;
  String tileID;
  List<TileObj> children;
  TileObj(this.title, [this.children = const <TileObj>[]]);
  TileObj.subject(this.title, this.tileID, [this.children = const <TileObj>[]]);
}

/*
//List to hold results
List<TileObj> _resultsList = <TileObj>[
  new TileObj(
    'University of Wollongong',
    <TileObj>[
      new TileObj('CSIT321 - Project (Annual)'),
      new TileObj('CSIT314 - Software Development Methodologies (Autumn)'),
    ],
  ),
  new TileObj(
    'University of Example',
    <TileObj>[
      new TileObj('ISIT307 - Backend Web Programming (Autumn)'),
      new TileObj('CSCI361 - Cryptography and Secure Applications (Autumn)'),
    ],
  )
];
*/

Future<List<Universities>> fetchUniversities(String s) async {

  String _request;
  //print('test');
//  if(QueryManager().universityList.isNotEmpty){
//    return QueryManager().universityList;
//  }



    if(getPriv() == 2){_request= "VIEW_OWNED_SUBJECTS";}
    else _request= "POPULATE_SUBJECTS";

  //(getPriv() == 2)?request= "VIEW_SUBJECTS":request= "POPULATE_SUBJECTS";

  var now = DateTime.now();

  var response = await http.post(



      'https://markit.mijdas.com/api/requests/subject/',
      body: jsonEncode({
        "request": "POPULATE_SUBJECTS",
        "username": s
      }) // change this to logged in username when time comes
      );
  print("response time = "+(DateTime.now().difference(now)).toString());
  if (response.statusCode == 200) {
//    print('response code:  200\n');
//    print('response body: ' + response.body);
    return universitiesFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    showDialog_1(
        _homeContext,
        "Error!",
        "Response Code: 404.\n\n\t\t\tNo Subjects Found.",
        "Close & Return",
        false);
  } else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}

List<Universities> universitiesFromJson(String str) =>
    new List<Universities>.from(
        json.decode(str).map((x) => Universities.fromJson(x)));

String universitiesToJson(List<Universities> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Universities {
  String institution;
  List<Subject> subjects;

  Universities({
    this.institution,
    this.subjects,
  });

  factory Universities.fromJson(Map<String, dynamic> json) => new Universities(
        institution: json["institution"],
        subjects: new List<Subject>.from(
            json["subjects"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "institution": institution,
        "subjects": new List<dynamic>.from(subjects.map((x) => x.toJson())),
      };
}

class Subject {
  String subjectCode;
  String id;

  Subject({
    this.subjectCode,
    this.id,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => new Subject(
        subjectCode: json["subject_code"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "subject_code": subjectCode,
        "id": id,
      };
}

String getSubjectName() {
  return _subjectName;
}
