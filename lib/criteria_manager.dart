import 'package:flutter/material.dart';

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

import './main.dart';

Route criteriaRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CriteriaManager(),
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

class CriteriaManager extends StatelessWidget {
  
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
        title: Text('Criteria'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {
              Navigator.push(context, PageThree());
              print("Hamburger Menu Clicked");
            },
          )
        ],
      ),
      body: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context, PageThree());
                },
                child: Text("Template Page, Click for Next Page."),
              ),
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

