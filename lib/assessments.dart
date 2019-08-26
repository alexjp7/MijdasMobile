import 'package:flutter/material.dart';

// Color lightGrey = Color(0xffBFD4DF);

class Assessments extends StatelessWidget {
  final List<String> assignments;
  Color _primaryColour = Color(0xff0069C0);
  Color _accentColour = Color(0xffBFD4DF);

  Assessments(this.assignments) {
    // print('[Assessments Widget] Constructor');
  }

  @override
  Widget build(BuildContext context) {
    // print('[Assessments Widget] build()');
    return Column(
      children: assignments
          .map((element) => Card(
                color: _accentColour,//Light Grey
                child: Column(
                  children: <Widget>[
                    // Image.asset('assets/mijdasLogo.png'),
                    Container(
                      // margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                      // width: 360.0,
                      height: 85.0,
                      alignment: Alignment(0.0, 0.0),

                      child: Text(element))
                  ],
                ),
              ))
          .toList(),
    );
  }
}
