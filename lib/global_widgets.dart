import 'package:flutter/material.dart';


//dialog_1 = custom popup prompt with passable title, message and button text. returns a screen upon closure.
void showDialog_1(BuildContext bctx, String title, String msg, String option) {
  showDialog(
    context: bctx,
    barrierDismissible: false, //user must select button
    builder: (BuildContext bctx) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(msg),
        actions: <Widget>[
          new FlatButton(
            child: new Text(option),
            onPressed: () {Navigator.of(bctx).pop();Navigator.of(bctx).pop();},
          ),
        ],
      );
    }
  );
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
            onPressed: () {Navigator.of(bctx).pop();},
          ),
        ],
      );
    }
  );
}

