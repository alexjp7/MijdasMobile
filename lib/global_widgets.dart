import 'package:flutter/material.dart';


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