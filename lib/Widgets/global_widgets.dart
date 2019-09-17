import 'package:flutter/material.dart';
import '../Functions/fetches.dart';
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
void showDialog_2(BuildContext bctx, String title, String msg, String option) {
  showDialog(
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

//global settings prompts
void onHoldSettings_HomeTile(BuildContext context, String selectedTitle) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text("Add Student To Subject: " + selectedTitle),
                onTap: () {
                  print("Add Student Click.");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text("Add Tutor to Subject: " + selectedTitle),
                onTap: () {
                  print("Add Tutor Click.");
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

void onHoldSettings_Assessments(BuildContext context, String selectedTitle) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add_comment),
                title: Text("Create Criteria For: " + selectedTitle),
                onTap: () {
                  print("Create Criteria Click.");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text("Toggle Activation For: " + selectedTitle),
                onTap: () {
                  print("Toggle Activation Click.");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}

//settings tile styling used globally
Widget settingsTile(IconData icon, String label, Function onTap) {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  TextStyle _labelStyle;

  if (label == "Sign Out")
    _labelStyle = TextStyle(fontSize: 20.0, color: Colors.red[900]);
  else
    _labelStyle = TextStyle(fontSize: 20.0);

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
            SizedBox(width: 24), //temporary to keep padding
            Row(
              children: <Widget>[
                // Icon(icon),
                SizedBox(width: 24),
                SizedBox(width: 10),
                Text(label, style: _labelStyle),
                // SizedBox(width: 105),
              ],
            ),
            SizedBox(width: 0),
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
                  color: Colors.black87,
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
                        color: Colors.black,
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
                    style: TextStyle(color: Colors.black54, fontSize: 16),
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
