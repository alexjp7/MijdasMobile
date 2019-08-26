import 'package:flutter/material.dart';

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

import './home.dart';
import './main.dart';
import './criteria_manager.dart';

Route homeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeManager(),
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

class HomeManager extends StatelessWidget {
  
  // Future<String> getData(String s) async {
  //   var response = await http.get(
  //     Uri.encodeFull(jsonURL+s),
  //     headers: {
  //       "Accept": "application/json"
  //     }
  //   );

  //   // Map<String, dynamic> fetchedData = json.decode(response.body);
  //   fetchedData = json.decode(response.body);
  //   print(fetchedData);
  // }
  
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
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {
              Navigator.push(context, criteriaRoute());
              print("Hamburger Menu Clicked");
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new PopulateTiles(_resultsList[index]);
        },
        itemCount: _resultsList.length,
      ),
      
      // ListView(
      //     physics: const AlwaysScrollableScrollPhysics(),
      //     padding: const EdgeInsets.all(8.0),
      //     children: <Widget>[
            
      //     ]),
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

class PopulateTiles extends StatelessWidget {
  Color _accentColour = Color(0xffBFD4DF);

  final TileObj fTile;
  PopulateTiles(this.fTile);

  @override
  Widget build(BuildContext context) {
    return _buildList(fTile);
  }

//widget to load tile list
  Widget _buildList(TileObj t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("Long Press"),
          onTap: () => print("Tap"),
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

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.title),
      // title: new Text(t.title, style: TextStyle(color: Colors.black),),
      children: t.children.map(_buildList).toList(),
    );
  }
}

//class structure for each tile object
class TileObj {
  String title;
  List<TileObj> children;
  TileObj(this.title, [this.children = const <TileObj>[]]);
}


//List to hold results
List<TileObj> _resultsList = <TileObj>[
  new TileObj(
    'University of Wollongong',
    <TileObj>[
      new TileObj('CSIT321 - Project (Annual)'),
      new TileObj('CSIT314 - Software Development Methodologies (Autumn)'),
    ],
  ),
  new TileObj(
    'University of Example',
    <TileObj>[
      new TileObj('ISIT307 - Backend Web Programming (Autumn)'),
      new TileObj('CSCI361 - Cryptography and Secure Applications (Autumn)'),
    ],
  )
];

