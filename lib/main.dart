import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import './assessment_manager.dart';
import './home_manager.dart';
import './signup_manager.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  // runApp(MyApp());
  runApp(MaterialApp(
    home: MyApp(),
    theme: themeData,
  ));
}

final ThemeData themeData = ThemeData(
  canvasColor: Color(0xffE1E2E1),
  accentColor: Color(0xff61747E),
  primaryColor: Color(0xff0069C0),
  secondaryHeaderColor: Color(0xffBFD4DF),
);

String searchedUser = "";

//base url as string
final String jsonURL =
    "https://markit.mijdas.com/api/requests/subject/read.php?username=";
//for storing json results globally
Map<String, dynamic> fetchedData;

class MyApp extends StatelessWidget {
  // Color _primaryColour = Color(0xff0069C0);
  // Color _primaryColour2 = Color(0xff2196F3);
  final searchController = TextEditingController();

  Future<String> getData(String s) async {
    var response = await http.get(Uri.encodeFull(jsonURL + s),
        headers: {"Accept": "application/json"});

    // Map<String, dynamic> fetchedData = json.decode(response.body);
    fetchedData = json.decode(response.body);
    print(fetchedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: TextField(
                // autofocus: false,
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Enter A Username To Query...",
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                controller: searchController,
              ),
            ),
            Container(
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          print("Searching: [" + searchController.text + "].");
                          searchedUser = searchController.text;
                          // getData(searchedUser); //commented out while back end was down
                          Navigator.push(context, homeRoute());
                        },
                        child: Text("Search"),
                      ),
                    ), 
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          print("Sign Up Clicked.");
                          Navigator.push(context, signUpRoute());
                        },
                        child: Text("Sign Up"),
                      ),
                    )
                  ],
                )),
          ])),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //       theme: ThemeData(
  //           brightness: Brightness.light,
  //           primarySwatch: Colors.lightBlue,
  //           accentColor: Colors.deepPurple),
  //       home: Scaffold(
  //         appBar: AppBar(
  //           backgroundColor: _primaryColour,
  //           leading: Padding(
  //             padding: EdgeInsets.only(left: 12),
  //             child: IconButton(
  //               icon: Icon(Icons.arrow_back_ios),
  //               onPressed: () {
  //                 print("Back Arrow Clicked");
  //               },
  //             ),
  //           ),
  //           title: Text('Assessments'),
  //           centerTitle: true,
  //           actions: <Widget>[
  //             IconButton(
  //               icon: Icon(Icons.dehaze),
  //               onPressed: () {
  //                 print("Hamburger Menu Clicked");
  //               },
  //             )
  //           ],
  //         ),
  //         body: ListView(
  //             physics: const AlwaysScrollableScrollPhysics(),
  //             padding: const EdgeInsets.all(8.0),
  //             children: <Widget>[
  //               AssessmentManager('Assignment 1'),
  //             ]),
  //         bottomNavigationBar: BottomAppBar(
  //           child: Container(
  //               height: 70.0,
  //               child: IconButton(
  //                 icon: Icon(Icons.more_horiz),
  //                 onPressed: () {
  //                   print("Bottom AppBar Pressed");
  //                 },
  //               )),
  //           color: _primaryColour2,
  //         ),
  //       )
  //       // AssessmentManager('Assignment 1'),),
  //       );
  // }
}

class PageTwo extends MaterialPageRoute<Null> {
  PageTwo()
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 1.0,
            ),
            body: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context, PageThree());
                },
                child: Text("Go to Page Three."),
              ),
            ),
          );
        });
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class PageThree extends MaterialPageRoute<Null> {
  PageThree()
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Last Page!"),
              backgroundColor: Theme.of(context).accentColor,
              elevation: 2.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            body: Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                },
                child: Text("Go Home!"),
              ),
            ),
          );
        });
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
