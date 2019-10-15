/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import 'package:flutter/material.dart';
//import 'package:mijdas_app/QueryManager.dart';

//local imports
//import '../main.dart';
import 'signin.dart';

import '../Functions/routes.dart';
import '../Functions/fetches.dart';

import '../Widgets/global_widgets.dart';

import '../Models/University.dart';
import '../Models/Subject.dart';
import '../Models/QueryManager.dart';

//data handling/processing imports
import 'dart:async';

String _subjectName;
BuildContext _homeContext;
Future<List<University>> _universitiesList;
Future<List<University>> _universitiesListCoord;
Future<List<University>> _universitiesListTutor;
bool coordIsSelectedList;
filterSwitchPainter switchPainter = filterSwitchPainter(
    "Coordinator", "Tutor", Color(0xff00508F), Color(0xffFFFFFF));

class HomePage extends StatefulWidget {
  HomePage(context) {
    _homeContext = context; //assigning buildcontext
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    _universitiesListTutor = null;
    _universitiesListTutor =
        fetchUniversities(getUsername(), _homeContext, false);
    if (QueryManager().isCoordinator) {
      //if is a coordinator
      _universitiesListCoord = null;
      _universitiesListCoord =
          fetchUniversities(getUsername(), _homeContext, true);
      _universitiesList = _universitiesListCoord;
      coordIsSelectedList = true;
    } else {
      _universitiesList = _universitiesListTutor;
      coordIsSelectedList = false;
    }
    switchPainter.setSelected(coordIsSelectedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Text("Home"),
          centerTitle: true,
        ),
        endDrawer: Drawer(
          child: Container(
            child: ListView(
              // padding: EdgeInsets.all(10.0),
              children: sideBar(context, getUsername()),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            _filterSwitch(context),
            Expanded(
                child: FutureBuilder<List<University>>(
              future: _universitiesList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      onRefresh: _refreshAssessmentsList,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return _buildUniversities(snapshot.data[index]);
                        },
                        itemCount: snapshot.data.length,
                      ));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                    child: CircularProgressIndicator()); //LOADING CIRCLE
              },
            )),
          ],
        ));
  }

  //widget to load tile list
  Widget _buildUniversities(University t) {
    return new GestureDetector(
      onLongPress: () {
        print("Long Press: [" +
            t.institution +
            "]. UserPriv: [" +
            QueryManager().isCoordinatorView.toString() +
            "].");
        if (QueryManager().isCoordinatorView)
          onHoldSettings_HomeHead(_homeContext, t.institution);
      },
      child: ExpansionTile(
        key: new PageStorageKey<int>(3),
        title: /*Container(
        child: */
            Text(
          t.institution /*, style: TextStyle(color: Colors.green)*/,
        ),
        children: t.subjects.map(_buildChildren).toList(),
      ),
    );
  }

  Widget _buildChildren(Subject t) {
    Color _accentColour = Color(0xffBFD4DF);
    return new ListTile(
        dense: true,
        enabled: true,
        isThreeLine: false,
        onLongPress: () {
          print("Long Press: [" +
              t.subjectCode +
              "]. UserPriv: [" +
              QueryManager().isCoordinatorView.toString() +
              "].");
          if (QueryManager().isCoordinatorView)
            onHoldSettings_HomeTile(_homeContext, t.subjectCode, t.id);
        },
        onTap: () {
          _subjectName = t.subjectCode;
          Navigator.push(_homeContext, assessmentRoute(t.id));
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
                child: Text(t.subjectCode),
              )
            ],
          ),
        ));
    // title: new Text(t.title));
  }

  Widget _filterSwitch(BuildContext context) {
    Widget _nestedPainting = CustomPaint(
      size: Size(130, 25),
      painter: switchPainter,
    );
    if (QueryManager().isCoordinator == true) {
      return Container(
        height: 32,
        width: MediaQuery.of(context).size.width,
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Material(color: Theme.of(context).primaryColor),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
              child: InkWell(
                borderRadius: BorderRadius.circular(25.0),
                onTap: () {
                  print("InkWell Clicked");
                  changeList();
                  switchPainter.setSelected(coordIsSelectedList);
                },

                child: FittedBox(
                  child: SizedBox(
                    width: 130,
                    height: 25,
                    child: _nestedPainting,
                  ),
                ),

              ))
        ]),
      );
    } else return Container();
  }

  void changeList() {
    if (coordIsSelectedList == true) {
      _universitiesList = _universitiesListTutor;
      coordIsSelectedList = false;
      QueryManager().isCoordinatorView=false;
    } else {
      _universitiesList = _universitiesListCoord;
      coordIsSelectedList = true;
      QueryManager().isCoordinatorView=true;
    }
    setState(() {});
  }
}

//fix for the other bit
Future<void> _refreshAssessmentsList() async {
  await (_universitiesListCoord = fetchUniversities(
      getUsername(), _homeContext, QueryManager().isCoordinator));
  _universitiesList = _universitiesListCoord;
  return;
}

String getSubjectName() {
  return _subjectName;
}
