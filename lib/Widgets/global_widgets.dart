import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'dart:math';
import '../Pages/AssessmentPage.dart';
import '../Functions/submits.dart';
import '../Functions/routes.dart';
//dialog_1 = custom popup prompt with passable title, message and button text. returns a screen upon closure.


void showDialog_1(BuildContext bctx, String title, String msg, String option,
    bool isDismissable) {
  showDialog(
      context: bctx,
      barrierDismissible: isDismissable, //user must select button
      builder: (BuildContext bctx) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text(option),
              onPressed: () {
                Navigator.of(bctx).pop();
                Navigator.of(bctx).pop();
              },
            ),
          ],
        );
      });
}

//dialog_2 = same as dialog_1 but doesnt go back a screen, only closes dialog box upon closure.
Future<void> showDialog_2 (BuildContext bctx, String title, String msg, String option) async {
  await showDialog(
      context: bctx,
      barrierDismissible: true, //user can close however they want
      builder: (BuildContext bctx) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text(option),
              onPressed: () {
                Navigator.of(bctx).pop();
              },
            ),
          ],
        );
      });
}



Future<String> displayDialogText(BuildContext context, String title, String msg, String option) async {
  TextEditingController _textFieldController = TextEditingController();
  String _textField;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: msg),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(option),
                onPressed: () {
                  _textField = _textFieldController.value.text;
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    return _textField;
}


//global settings prompts
void onHoldSettings_HomeTile(BuildContext context, String selectedTitle, String sNum) async{
  await showModalBottomSheet(
      context: context,

      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text("Add Student To Subject: " + selectedTitle),
                onTap: () async {
                  print("Add Student Click.");
                  //ADD A DIALOG BOX FOR NAME ENTRY

                  String _stuName= await displayDialogText(context,"Add Student","Student Identifier","Submit");

                  print(_stuName);
                  await addStudent(_stuName, sNum,context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text("Add Tutor to Subject: " + selectedTitle),
                onTap: () async {
                  print("Add Tutor Click.");
                  String tutName= await displayDialogText(context,"Add Tutor","Tutor Username","Submit");
                  print(tutName);
                  print("Displaybox done");
                  await addTutor(tutName,sNum,context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}

void onHoldSettings_HomeHead(BuildContext context, String selectedTitle) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text("Create Subject For: " + selectedTitle),
                onTap: () {
                  print("Create Subject Click.");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}

Future<bool> onHoldSettings_Assessments(BuildContext context, String selectedTitle, String aNum) async {


  await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc)   {
         return Container(
          child: Wrap(
            children: <Widget>[
//              ListTile(
//                leading: Icon(Icons.add_comment),
//                title: Text("Create Criteria For: " + selectedTitle),
//                onTap: () {
//                  print("Create Criteria Click.");
//                  Navigator.pop(context);
//
//                },
//              ),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text("Toggle Activation For: " + selectedTitle),
                onTap: () async {
                  print("TEST Toggle Activation Click for assignment: "+aNum);
                  await toggleActivation(aNum, context);
                  print("afterActivate");
                  //definitely after activation
                  //await refreshAssList();
                  Navigator.pop(context);

                },
              ),
            ],
          ),
        );
      });
  //await refreshAssList();
  print("TEST");

  return true;
}

//change to a listview?
List<Widget> sideBar(context,username){
  return [
    settingsHeader(context, username),
    settingsTile(Icons.person, "Profile", () {
      Navigator.push(context, profileRoute());
    print("Profile Clicked.");
    }),
    settingsTile(Icons.person, "Announcements", () {
      Navigator.push(context, announcementRoute());
    print("Announcements Clicked.");
    }),
//    settingsTile(Icons.person, "Calendar", () {
//      Navigator.push(context, settingsRoute());
//    print("Calendar Clicked.");
//    }),
//    settingsTile(Icons.person, "Board", () {
//    print("Job Board Clicked.");
//    }),
    settingsTile(Icons.person, "Settings", () {
      Navigator.push(context, settingsRoute());
    print("Settings Clicked.");
    }),
    settingsTile(Icons.person, "Sign Out", () {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    print("Sign Out Clicked.");
    }),
  ];

}


//settings tile styling used globally
Widget settingsTile(IconData icon, String label, Function onTap) {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  TextStyle _labelStyle;

  if (label == "Sign Out")
    _labelStyle = TextStyle(fontSize: 20.0, color: Colors.red[900]);
  else
    _labelStyle = TextStyle(fontSize: 20.0);

//  return Center(
//    child:InkWell(
//      onTap: onTap,
//      child:Padding(
//        padding:EdgeInsets.fromLTRB(8.0, 0, 8.0, 0) ,
//        child: Container(
//          height: 60,
//          child:Text(label, style: _labelStyle,),
//        ),
//      )
//    ),
//  );

  return Padding(
    padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
    child: InkWell(
      splashColor: _mainBackdrop,
      onTap: onTap,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Icon(Icons.arrow_left),
            SizedBox(width: 0), //temporary to keep padding
            Row(
              children: <Widget>[
                // Icon(icon),
               // SizedBox(width: 24),
               // SizedBox(width: 10),
                Text(label, style: _labelStyle),
                // SizedBox(width: 105),
              ],
            ),
          //  SizedBox(width: 0),
            SizedBox(width: 0),
          ],
        ),
      ),
    ),
  );
}

//headder widget used for drawers globally
Widget settingsHeader(BuildContext context, String username) {
  return DrawerHeader(

    decoration: const BoxDecoration(

      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF0069C0),
          Color(0xFF026AC1),
          Color(0xFF71ABDC),
        ],
      ),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          width: 280, //272 for width of area
          height: 140, //138 for height of area
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Material(color: Colors.redAccent),
              Positioned(
                top: 0,
                left: 0,
                width: 30,
                height: 30,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: 70,
                left: 105,
                width: 200,
                height: 100,
                child: RichText(
                  text: TextSpan(
                    text: (username),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Positioned(
                top: 13,
                left: 115,
                width: 50,
                height: 30,
                child: RichText(
                  text: TextSpan(
                    text: ("MarkIt"),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              /*Positioned(
                            top: 20,
                            left: 85,
                            width: 100,
                            height: 100,
                            child: Material(
                              elevation: 10,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/mijdasLogo.png',
                                    width: 100,
                                    height: 100,
                                  )),
                            ),
                          ),*/
            ],
          ),
        ),
      ],
    ),
  );
}

//CustomPainting class used to draw/redraw the custom filter switch.
class filterSwitchPainter extends CustomPainter {
  
  bool _isSelected;
  String _sliderOption1;
  String _sliderOption2;
  Color _backdropColour;
  Color _highlightColour;
  Color _textColour1;
  Color _textColour2;

  filterSwitchPainter(String option1, String option2, Color back, Color highlight){
    this._sliderOption1 = option1;
    this._sliderOption2 = option2;
    this._backdropColour = back;
    this._highlightColour = highlight;
    this._isSelected = true;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    final bkgPaint = Paint()..color = _backdropColour;
    final selPaint = Paint()..color = _highlightColour;
    final testPaint = Paint()..color = Color(0xffFF0000);

    if(_isSelected){
      //location1
      _textColour1 = _backdropColour;
      _textColour2 = _highlightColour;
    } else {
      //location2
      _textColour1 = _highlightColour;
      _textColour2 = _backdropColour;
    }

    final textToPaint_Left = TextPainter(
      text: TextSpan(
        text: _sliderOption1, //Focused    Other
        style: TextStyle(
          color: _textColour1,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    final textToPaint_Right = TextPainter(
      text: TextSpan(
        text: _sliderOption2,
        style: TextStyle(
          color: _textColour2,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    );

    textToPaint_Left.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textToPaint_Right.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    //draw background
    canvas.drawCircle(Offset(size.width/10, size.height/2), 13, bkgPaint);
    canvas.drawCircle(Offset(size.width/1.1-1, size.height/2), 13, bkgPaint);
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: 105, height: 26), bkgPaint);

    //draw selected

    if(_isSelected){
      //location1
      canvas.drawCircle(Offset(size.width/10, size.height/2), 13, selPaint);
      canvas.drawCircle(Offset(size.width/2, size.height/2), 13, selPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(size.width/3.25, size.height/2), width: 50, height: 26), selPaint);
    } else {
      //location2
      canvas.drawCircle(Offset(size.width/1.27, size.height/2), 13, selPaint);
      canvas.drawCircle(Offset(size.width/1.1-1, size.height/2), 13, selPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(size.width/1.175, size.height/2), width: 15, height: 26), selPaint);
    }
    
    
    //draw text labels
    textToPaint_Left.paint(canvas, Offset(4, size.height/5));
    textToPaint_Right.paint(canvas, Offset(size.width/1.4, size.height/5));

  }

  @override
  bool shouldRepaint(filterSwitchPainter old) {
    //print("shouldRepaint? "+ (old._isSelected != _isSelected).toString());
    return old._isSelected != _isSelected;
  }

  bool getSelected() {
    return _isSelected;
  }
  void setSelected(bool b) {
    _isSelected = b;
  }

}



