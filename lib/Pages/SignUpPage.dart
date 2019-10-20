/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import 'package:flutter/material.dart';
import '../Widgets/global_widgets.dart';

// import './AssessmentPage.dart';
// import './HomePage.dart';
// import './signup.dart';
// import './main.dart';
//
//import 'dart:async';
//import 'dart:convert';
//import 'package:http/http.dart' as http;

Color _buttonColour = new Color(0xff0069C0);
String _username;
String _email;
String _password;

Route signUpRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignUp(),
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

class SignUp extends StatelessWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController_2 = TextEditingController();
  ScrollController _scrollController = ScrollController();

  //jump the screen down - the animation looked smoother but was buggy, decided to use Jump for prototype demo
  _scrollToFields() {
    // print("\n\n\nMETHOD CALLED\n\n\n");
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent - 20.0);
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
              height: 270,
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: "Email",
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(color: Colors.white70)),
                      ),
                      controller: emailController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(120, 10, 120, 10),
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
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
                    margin: EdgeInsets.fromLTRB(120, 10, 120, 10),
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(fontSize: 12),
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(color: Colors.white70)),
                      ),
                      controller: passwordController_2,
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
                                if (passwordController.text == passwordController_2.text) {
                                  _username = usernameController.text;
                                  _password = passwordController.text;
                                  _email = emailController.text;
                                  // getData(searchedUser); //commented out while back end was down
                                  // showDialog_1(context, "Success!", "Signup Was a success!\nHead back to the home screen and try signing in with your new details!", "Close and Return", false);
                                  showDialog_1(context, "Sorry!", "Signup is currently unavailable via the app.\nHead back to the home screen and try signing up using the webpage link.", "Close and Return", false);
                                } else {
                                  showDialog_2(context, "Error", "There was a problem with the information entered, make sure all fields are correct.", "Close");
                                }
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
              top: 105,
              left: 145,
              width: 330,
              height: 85,
              child: RichText(
                text: TextSpan(
                  text: ("  Tutor\nSign Up"),
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
