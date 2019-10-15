/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/

//can we rewrite populatetiles so that it takes in an assessment rather than another thing

import 'dart:ffi';

import 'package:MarkIt/Models/CriteriaDecode.dart';
import 'package:MarkIt/Models/QueryManager.dart';
import 'package:flutter/material.dart';

//local imports
import 'SignInPage.dart';
//import 'StudentsPage.dart';


import '../Functions/routes.dart';
import '../Functions/fetches.dart';

import '../Widgets/global_widgets.dart';

import '../Models/Assessment.dart';

//data handling/processing imports
import 'dart:async';
//import 'dart:convert';

//import 'package:http/http.dart' as http;

BuildContext _assessmentContext;
String _assessmentID;
String _assessmentName;
String _assessmentMaxMark;
Future<List<Assessment>> _assessmentList;
List<List<CriteriaDecode>> _critDecodes ;


class AssessmentPage extends StatefulWidget {

  AssessmentPage(context, s){
    _critDecodes= List<List<CriteriaDecode>>();
    _assessmentContext = context; //assigning page buildcontext
    _assessmentID = s; //assigning page ID
  }

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {

  @override
  void initState() {
    super.initState();
    _assessmentList = fetchAssessments(_assessmentID,_assessmentContext, QueryManager().isCoordinatorView);
  }

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
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            // padding: EdgeInsets.all(10.0),
            children:
              sideBar(context, getUsername())
          ),
        ),
      ),
      body: FutureBuilder<List<Assessment>>(
        future: _assessmentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
//            List<TileObj> _parentListItems = new List<TileObj>();
//
//            for (int i = 0; i < snapshot.data.length; i++)  {
//
//            }
            return RefreshIndicator(
                onRefresh: _refreshAssList,
                child:  ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _buildList(snapshot.data[index]);
              },
              itemCount: snapshot.data.length,
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator()); //LOADING CIRCLE
        },
      ),
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

  Future<Null> _refreshAssList() async {
    //_assessmentList = null;

    print("REFRESHING");
    //DO SOMETHING HERE
    await(_assessmentList = fetchAssessments(_assessmentID,_assessmentContext,QueryManager().isCoordinatorView));
    print("REFRESHED");

    setState(() {

    });
    return null;
  }
  Widget _buildList(Assessment t) {
    Color _accentColour = Color(0xffBFD4DF);
    // if (t.children.isEmpty)
    //List<int>activeId = List<int>();

    if (t.isActive == "0")  {
      _accentColour = Color(0x11000000);
      //activeId.add(-1);

    }
    else {
    }

    return new ListTile(
        dense: true,
        enabled: true,
        isThreeLine: false,
        onLongPress: () async {
          print("Long Press: [" +
              t.name +
              "]. UserPriv: [" +
              QueryManager().isCoordinatorView.toString() +
              "].");
          if (QueryManager().isCoordinatorView) {
            //_assessmentList=null;
            print(t.name+t.id);
            await onHoldSettings_Assessments(_assessmentContext, t.name, t.id);//pass assessment here once rewritten
            setState(() {

            });

          }
        },
        onTap: () {
          _assessmentName = t.name;
          _assessmentMaxMark = t.maxMark;
          Navigator.push(context, studentsRoute(t.id));
        },
        selected: true,
        title: new Card(
          color: _accentColour,
          child: Column(
            children: <Widget>[
              Container(
                height: 85.0,
                alignment: Alignment(0.0, 0.0),
                child: Text(t.name),
              )
            ],
          ),
        ));
  }
}



String getAssessmentName() {
  return _assessmentName;
}

String getAssessmentMaxMark() {
  return _assessmentMaxMark;
}

Future<bool> refreshAssList() async {
  print("REFRESHING");
  await(_assessmentList = fetchAssessments(_assessmentID,_assessmentContext, QueryManager().isCoordinatorView));
  print("REFRESHED");
  return true;
}

