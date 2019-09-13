import 'package:flutter/material.dart';

import './assessment.dart';
import './home.dart';
import './signup.dart';
import './global_widgets.dart';
import './main.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Color _buttonColour = new Color(0xff0069C0);
String searchedUser;
final String jsonURL =
    "https://markit.mijdas.com/api/requests/subject/read.php?username=";
//for storing json results globally
Map<String, dynamic> fetchedData;

Route signInRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class SignIn extends StatelessWidget {
  // Color _primaryColour = Color(0xff0069C0);
  // Color _primaryColour2 = Color(0xff2196F3);
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<String> getData(String s) async {
    var response = await http.get(Uri.encodeFull(jsonURL + s),
        headers: {"Accept": "application/json"});

    // Map<String, dynamic> fetchedData = json.decode(response.body);
    fetchedData = json.decode(response.body);
    print(fetchedData);
  }

  //jump the screen down - the animation looked smoother but was buggy, decided to use Jump for prototype demo
  _scrollToFields() {
    // print("\n\n\nMETHOD CALLED\n\n\n");
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 250), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            Container(
              width: 500,
              height: 330,
              child: _banner(context),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(120, 10, 120, 10),
                    alignment: Alignment.center,
                    child: TextField(
                      // autofocus: false,
                      // textAlign: TextAlign.center,//cant use this as it crashes flutter - known bug.
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        // hintText: "Username..",
                        labelText: "Username",
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(color: Colors.white70)),
                      ),
                      controller: usernameController,
                      onChanged: (v) {
                        _scrollToFields();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(120, 10, 120, 10),
                    alignment: Alignment.center,
                    child: TextField(
                      // autofocus: false,
                      // textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        // hintText: "Password..",
                        labelText: "Password",
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(color: Colors.white70)),
                      ),
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ButtonTheme(
                            minWidth: 130.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () {
                                // if (passwordController.text == "") {
                                  print("Searching: [" +
                                      usernameController.text +
                                      "].");
                                  searchedUser = usernameController.text;
                                  // getData(searchedUser); //commented out while back end was down
                                  Navigator.push(context, homeRoute());
                                // } else {
                                //   showDialog_2(context, "Login Failed", "Login Details Incorrect.", "Close");
                                // }
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: ("Submit"),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              color: _buttonColour,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(7.0)),
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              print("Forgotten Password Clicked.");
                              Navigator.push(context, signUpRoute());
                            },
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
              top: 20,
              left: 0,
              // width: 0,
              // height: 40,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                  print("Back Arrow Clicked");
                },
              ),
            ),
            Positioned(
              top: 125,
              left: 150,
              width: 330,
              height: 40,
              child: RichText(
                text: TextSpan(
                  text: ("Sign In"),
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
                  text: ("MarkIt"),
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
