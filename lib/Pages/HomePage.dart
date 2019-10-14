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
//import 'AssessmentPage.dart';

import '../Functions/routes.dart';
import '../Functions/fetches.dart';

import '../Widgets/global_widgets.dart';

import '../Models/University.dart';
import '../Models/Subject.dart';
// import './criteria_manager.dart';



//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String _subjectName;
BuildContext _homeContext;
Future<List<University>> _universitiesList;
Future<List<University>> _universitiesListCoord;
Future<List<University>> _universitiesListTutor;
bool coordIsSelectedList;
filterSwitchPainter switchPainter = filterSwitchPainter("Coordinator", "Tutor", Color(0xff00508F),Color(0xffFFFFFF));



class HomePage extends StatefulWidget {

  HomePage(context){
    _homeContext = context; //assigning buildcontext
  }

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{

  @override
  void initState() {
    super.initState();
    _universitiesListTutor = fetchUniversities(getUsername(),_homeContext, false);
    if((getPriv() == 2)){

      //if is a coordinator
      _universitiesListCoord = fetchUniversities(getUsername(),_homeContext, true);
      _universitiesList = _universitiesListCoord;
      coordIsSelectedList = true;
    }
    else _universitiesList = _universitiesListTutor;
    coordIsSelectedList = false;
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // leading:Container(),
        automaticallyImplyLeading: false,
        //  leading: Padding(
        //    padding: EdgeInsets.only(left: 12),
        //    child: _filterSwitch(context),
           /*IconButton(
             icon: Icon(Icons.arrow_back_ios),
             onPressed: () {
              //  Navigator.pop(context);
               print("Back Arrow Clicked");
             },
           ),*/
        //  ),
/*                  leading: Padding(
           padding: EdgeInsets.only(left: 12),
           child: IconButton(
             icon: Icon(Icons.arrow_back_ios),
             onPressed: () {
               Navigator.pop(context);
               print("Back Arrow Clicked");
             },
           ),
         ),*/
        // title: Text('Home'),
        // title: _filterSwitch(context),
        title: Column(

          children: <Widget>[
            Text("Home"),
            SizedBox(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[_filterSwitch(context),]
            ),

            // SizedBox(
            //   width: 35,
            // ),


          ],
        ),
        // centerTitle: true,
      ),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            // padding: EdgeInsets.all(10.0),
            children:sideBar(context, getUsername()),
          ),
        ),
      ),
      body: FutureBuilder<List<University>>(
        future: _universitiesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //_universitiesList = snapshot.data;

            //QueryManager().universityList=snapshot.data;
//
//            List<TileObj> _parentListItems = new List<TileObj>();
//
//            for (int i = 0; i < snapshot.data.length; i++) {
//              List<TileObj> _childrenListItems = new List<TileObj>();
//              for (int i2 = 0; i2 < snapshot.data[i].subjects.length; i2++) {
//                _childrenListItems.add(new TileObj.subject(
//                    snapshot.data[i].subjects[i2].subjectCode,
//                    snapshot.data[i].subjects[i2].id));
//              }
//              _parentListItems.add(new TileObj(
//                  snapshot.data[i].institution, _childrenListItems));
//            }
            return RefreshIndicator(
                onRefresh: _refreshAssessmentsList,
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                // homepageContext = context; //pass and store the page context globally instead of carrying it with each tile.
                return  _buildUniversities(snapshot.data[index]);
              },
              itemCount: snapshot.data.length,
            ));



          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator()); //LOADING CIRCLE
        },
      ),
    );
  }

  //widget to load tile list
  Widget _buildUniversities(University  t) {
    return new GestureDetector(
      onLongPress: () {
        print("Long Press: [" +
            t.institution +
            "]. UserPriv: [" +
            getPriv().toString() +
            "].");
        if (getPriv() == 2) onHoldSettings_HomeHead(_homeContext, t.institution);
      },
      child: ExpansionTile(
        key: new PageStorageKey<int>(3),
        title: /*Container(
        child: */
        Text(
          t.institution /*, style: TextStyle(color: Colors.green)*/,
        ),
        // alignment: Alignment.center,
        // ),
        // trailing: Text(""),
        children: t.subjects.map(_buildChildren).toList(),
      ),
    );
  }

  Widget _buildChildren(Subject t){
    Color _accentColour = Color(0xffBFD4DF);
    return new ListTile(
        dense: true,
        enabled: true,
        isThreeLine: false,
        onLongPress: () {
          print("Long Press: [" +
              t.subjectCode +
              "]. UserPriv: [" +
              getPriv().toString() +
              "].");
          if (getPriv() == 2) onHoldSettings_HomeTile(_homeContext, t.subjectCode,t.id);
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

      return InkWell(
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
        // Container(
        //   // child: InkWell(
        //     child: Icon(Icons.arrow_back_ios),
        //     // ),
        // ),
      );


  }
  void changeList(){
    if(coordIsSelectedList==true){
      _universitiesList = _universitiesListTutor;
      coordIsSelectedList=false;
    }
    else{
      _universitiesList = _universitiesListCoord;

      coordIsSelectedList=true;
    }
    setState(() {

    });
  }
}

//class structure for each tile object
//class TileObj {
//  String title;
//  String tileID;
//  List<TileObj> children;
//  TileObj(this.title, [this.children = const <TileObj>[]]);
//  TileObj.subject(this.title, this.tileID, [this.children = const <TileObj>[]]);
//}

//Widget to handle the filtering


//fix for the other bit
Future<void> _refreshAssessmentsList() async {
  await (_universitiesListCoord = fetchUniversities(getUsername(),_homeContext, (getPriv() == 2)));
  _universitiesList=_universitiesListCoord;
  return;
}

String getSubjectName() {
  return _subjectName;
}
