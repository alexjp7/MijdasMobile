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
// import './criteria_manager.dart';



//data handling/processing imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String _subjectName;
BuildContext _homeContext;
Future<List<Universities>> _universitiesList;



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
    _universitiesList = fetchUniversities(getUsername(),_homeContext, (getPriv() == 2));
  }

@override
Widget build(BuildContext context) {



  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading:Container(),
//        leading: Padding(
//          padding: EdgeInsets.only(left: 12),
//          child: IconButton(
//            icon: Icon(Icons.arrow_back_ios),
//            onPressed: () {
//              Navigator.pop(context);
//              print("Back Arrow Clicked");
//            },
//          ),
//        ),
      title: Text('Home'),
      centerTitle: true,
    ),
    endDrawer: Drawer(
      child: Container(
        child: ListView(
          // padding: EdgeInsets.all(10.0),
          children:sideBar(context, getUsername()),
        ),
      ),
    ),
    body: FutureBuilder<List<Universities>>(
      future: _universitiesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //_universitiesList = snapshot.data;

          //QueryManager().universityList=snapshot.data;

          List<TileObj> _parentListItems = new List<TileObj>();

          for (int i = 0; i < snapshot.data.length; i++) {
            List<TileObj> _childrenListItems = new List<TileObj>();
            for (int i2 = 0; i2 < snapshot.data[i].subjects.length; i2++) {
              _childrenListItems.add(new TileObj.subject(
                  snapshot.data[i].subjects[i2].subjectCode,
                  snapshot.data[i].subjects[i2].id));
            }
            _parentListItems.add(new TileObj(
                snapshot.data[i].institution, _childrenListItems));
          }
          return RefreshIndicator(
              onRefresh: _refreshAssessmentsList,
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              // homepageContext = context; //pass and store the page context globally instead of carrying it with each tile.
              return new PopulateTiles(_parentListItems[index]);
            },
            itemCount: _parentListItems.length,
          ));



        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator()); //LOADING CIRCLE
      },
    ),
    /*

        Maybe leave this here too for reference, we can clean it all up at the end?

      LEGACY CODE WITH LISTVIEWBUILDER
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new PopulateTiles(_resultsList[index]);
        },
        itemCount: _resultsList.length,
      ),
      */

    // ListView(
    //     physics: const AlwaysScrollableScrollPhysics(),
    //     padding: const EdgeInsets.all(8.0),
    //     children: <Widget>[

    //     ]),
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
}

class PopulateTiles extends StatelessWidget {


  final TileObj fTile;
  // BuildContext contextT;
  PopulateTiles(this.fTile);

  @override
  Widget build(BuildContext context) {
    return _buildList(fTile);
  }

//widget to load tile list
  Widget _buildList(TileObj t) {
    Color _accentColour = Color(0xffBFD4DF);
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () {
            print("Long Press: [" +
                t.title +
                "]. UserPriv: [" +
                getPriv().toString() +
                "].");
            if (getPriv() == 2) onHoldSettings_HomeTile(_homeContext, t.title,t.tileID);
          },
          onTap: () {
            _subjectName = t.title;
            Navigator.push(_homeContext, assessmentRoute(t.tileID));
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
                  child: Text(t.title),
                )
              ],
            ),
          ));
    // title: new Text(t.title));

    return new GestureDetector(
      onLongPress: () {
        print("Long Press: [" +
            t.title +
            "]. UserPriv: [" +
            getPriv().toString() +
            "].");
        if (getPriv() == 2) onHoldSettings_HomeHead(_homeContext, t.title);
      },
      child: ExpansionTile(
        key: new PageStorageKey<int>(3),
        title: /*Container(
        child: */
            Text(
          t.title /*, style: TextStyle(color: Colors.green)*/,
        ),
        // alignment: Alignment.center,
        // ),
        // trailing: Text(""),
        children: t.children.map(_buildList).toList(),
      ),
    );
  }
}

//class structure for each tile object
class TileObj {
  String title;
  String tileID;
  List<TileObj> children;
  TileObj(this.title, [this.children = const <TileObj>[]]);
  TileObj.subject(this.title, this.tileID, [this.children = const <TileObj>[]]);
}



Future<void> _refreshAssessmentsList() async {
  await (_universitiesList = fetchUniversities(getUsername(),_homeContext, (getPriv() == 2)));
}

String getSubjectName() {
  return _subjectName;
}
