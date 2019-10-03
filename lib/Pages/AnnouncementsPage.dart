/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import 'package:flutter/material.dart';

//import 'package:mijdas_app/Pages/CriteriaPage.dart' as prefix0;
//
//import 'package:pie_chart/pie_chart.dart';

//local imports
//import 'CriteriaPage.dart';
//import 'AssessmentPage.dart';
import 'signin.dart';
//import 'HomePage.dart';


import '../Widgets/global_widgets.dart';

//import '../Models/Assessment.dart';

//data handling/processing imports
//import 'dart:async';
//import 'dart:convert';
//
//import 'package:http/http.dart' as http;



class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
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
          title: Text('Announcements'),
          centerTitle: true,
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.dehaze),
          //     onPressed: () {
          //       // Navigator.push(context, PageThree());
          //       // ScaffoldState.openEndDrawer();
          //       print("Hamburger Menu Clicked");
          //     },
          //   )
          // ],
        ),
        endDrawer: Drawer(
          child: Container(
            child: ListView(
              // padding: EdgeInsets.all(10.0),
              children: sideBar(context, getUsername()),
            ),
          ),
        ),
        body: ListTile(title:Text("No announcements yet"))

    );
  }
}
