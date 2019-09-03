import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './home.dart';
import './main.dart';
import './criteria_manager.dart';

Route homeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeManager(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

class HomeManager extends StatelessWidget {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {
              Navigator.push(context, criteriaRoute());
              print("Hamburger Menu Clicked");
            },
          )
        ],
      ),
      body: FutureBuilder<List<Universities>>(
              future: fetchUniversities(searchedUser),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TileObj> _parentListItems = new List<TileObj>();

                  for(int i = 0; i < snapshot.data.length; i++){
                    List<TileObj> _childrenListItems = new List<TileObj>();
                    for(int i2 = 0; i2 < snapshot.data[i].subjects.length; i2++){
                      _childrenListItems.add(new TileObj(snapshot.data[i].subjects[i2].subjectCode));
                    }
                    _parentListItems.add(new TileObj(snapshot.data[i].institution, _childrenListItems));
                  }
                  return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
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

class PopulateTiles extends StatelessWidget {
  Color _accentColour = Color(0xffBFD4DF);

  final TileObj fTile;
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
          onLongPress: () => print("Long Press: ["+t.title+"]."),
          onTap: () => print("Tap: ["+t.title+"]."),
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

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.title),
      // title: new Text(t.title, style: TextStyle(color: Colors.black),),
      children: t.children.map(_buildList).toList(),
    );
  }
}

//class structure for each tile object
class TileObj {
  String title;
  List<TileObj> children;
  TileObj(this.title, [this.children = const <TileObj>[]]);
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
  print('test');
  var response = await http.post(
      'https://markit.mijdas.com/api/requests/subject/',
      body: jsonEncode({
        "request": "POPULATE_SUBJECTS",
        "username": s
      }) // change this to logged in username when time comes
      );

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return universitiesFromJson(response.body);
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
