import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:mijdas_app/signup_manager.dart';

//local imports
import './main.dart';
import './criteria_manager.dart';
import './home_manager.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


String assessmentID;

Route assessmentRoute(String s) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AssessmentManager(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      assessmentID = s;//assigning page ID
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}


class AssessmentManager extends StatelessWidget {

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
      body: FutureBuilder<List<Assessment>>(
              future: fetchAssessments(assessmentID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TileObj> _parentListItems = new List<TileObj>();

                  for(int i = 0; i < snapshot.data.length; i++){
                    _parentListItems.add(new TileObj(snapshot.data[i].name, snapshot.data[i].id, snapshot.data[i].a_number));
                  }
                  return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return new PopulateTiles(_parentListItems[index], context);
                        },
                        itemCount: _parentListItems.length,
                      );


                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator()); //LOADING CIRCLE
              },
            ),
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
  BuildContext contextT;
  PopulateTiles(this.fTile, [this.contextT]);

  @override
  Widget build(BuildContext context) {
    return _buildList(fTile);
  }

//widget to load tile list
  Widget _buildList(TileObj t) {
    // if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("Long Press: ["+t.title+"]."),
          onTap: () {
            print("Tap: ["+t.title+"].");
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

    // return new ExpansionTile(
    //   key: new PageStorageKey<int>(3),
    //   title: new Text(t.title),
    //   // title: new Text(t.title, style: TextStyle(color: Colors.black),),
    //   children: t.children.map(_buildList).toList(),
    // );
  }
}

//class structure for each tile object
class TileObj {
  String title;
  String tileID;
  String tileANum;
  TileObj(this.title, this.tileID, this.tileANum);
}

Future<List<Assessment>> fetchAssessments(String s) async {
  var response = await http.post(
      'https://markit.mijdas.com/api/assessment/',
      body: jsonEncode({
        "request": "VIEW_ASSESSMENT",
        "subject_id": s
      }) 
      );

  if (response.statusCode == 200) {
    print('response code:  200\n');
    print('response body: ' + response.body);
    return assessmentsFromJson(response.body);
  } else if (response.statusCode == 404) {
    print('response code:  404\n');
    //navigate to an error page displaying lack of assessment error
    return assessmentsFromJson(response.body);
  } 
  else {
    print('response code: ' + response.statusCode.toString());
    print('response body: ' + response.body);
    throw Exception(
        'Failed to load post, error code: ' + response.statusCode.toString());
  }
}



List<Assessment> assessmentsFromJson(String str) =>
  new List<Assessment>.from(json.decode(str)["records"].map((x) => Assessment.fromJson(x)));


class Assessment {
  String id;
  String a_number;
  String name;

  Assessment({
    this.id,
    this.a_number,
    this.name,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) => new Assessment(
        id: json["id"],
        a_number: json["a_number"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "a_number": a_number,
        "name": name,
      };
}

