//Got lost trying to figure multi pages out - will need it explained after/before meeting pls xoxo - this code is ready for posts - joel
import 'package:flutter/material.dart';

//local imports
import './home.dart';
import './students.dart';
import './assessment.dart';

//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';

Student selectedStudent;
String assId;


Route CriteriaRoute(Student s,String assID) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Criteria(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      selectedStudent = s; //assigning page ID
      assId = assID;
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}


class Criteria extends StatelessWidget{
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
      body: FutureBuilder(

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


class CriteriaObj{
  String name;
  int iD,elementType,maxMark;
  double value;
  CriteriaObj(this.name, this.iD, this.elementType, this.maxMark,this.value);
}
