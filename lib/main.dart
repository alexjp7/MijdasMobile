import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import './assessment.dart';
import './home.dart';
import './signup.dart';
import './signin.dart';

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
  // brightness: Brightness.dark,
  canvasColor: Color(0xffE1E2E1), //White Background
  accentColor: Color(0xff61747E), //dark grey
  primaryColor: Color(0xff0069C0), //darker blue
  secondaryHeaderColor: Color(0xffBFD4DF), //light grey
);

class MyApp extends StatelessWidget {
  // Color _primaryColour = Color(0xff0069C0);
  // Color _primaryColour2 = Color(0xff2196F3);
  Color _buttonColour = new Color(0xff0069C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: 500,
            height: 370,
            child: _banner(context),
          ),
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: ButtonTheme(
                          minWidth: 130.0,
                          height: 50.0,
                          child: RaisedButton(
                            onPressed: () {
                              print("Sign In Clicked.");
                              Navigator.push(context, signInRoute());
                            },
                            child: RichText(
                              text: TextSpan(
                                text: ("Sign In"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            color: _buttonColour,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: RaisedButton(
                          onPressed: () {
                            print("Sign Up Clicked.");
                            Navigator.push(context, signUpRoute());
                          },
                          child: Text("Sign Up"),
                          color: _buttonColour,
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.looks_one),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.looks_two),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.looks_3),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          text: ("Mijdas Tech"),
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}

Widget _banner(BuildContext context) {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500, //415 for width of pixel
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xFF0069C0),
                    Color(0xFF026AC1),
                    Color(0xFF71ABDC),
                    // Color(0xFF0D47A1),
                    // Color(0xFF1976D2),
                    // Color(0xFF42A5F5),
                  ],
                ),
              ),
              child: Material(color: Colors.transparent),
            ),
            Positioned(
              top: 125,
              left: 150,
              width: 330,
              height: 40,
              child: RichText(
                text: TextSpan(
                  text: ("MarkIt"),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 175,
              width: 80,
              height: 40,
              child: RichText(
                text: TextSpan(
                  text: (""),
                  style: TextStyle(color: Colors.black54, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

//following pages are test template pages.
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
