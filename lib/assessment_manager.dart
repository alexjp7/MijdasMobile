import 'package:flutter/material.dart';

import './assessments.dart';

class AssessmentManager extends StatefulWidget {
  final String startingAssessment;

  AssessmentManager(this.startingAssessment) {
    // print('[AssessmentsManager Widget] Constructor');
  }

  @override
  State<StatefulWidget> createState() {
    // print('[AssessmentsManager Widget] createState()');
    return _AssessmentManagerState();
  }
}

class _AssessmentManagerState extends State<AssessmentManager> {
  List<String> _assignments = [];
  int _assCount = 2;
  Color _primaryColour = Color(0xff0069C0);

  @override
  void initState() {
    // print('[AssessmentsManager State] initState()');
    _assignments.add(widget.startingAssessment);
    super.initState();
  }

  @override
  void didUpdateWidget(AssessmentManager oldWidget) {
    // print('[AssessmentsManager State] didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print('[AssessmentsManager State] build()');
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: RaisedButton(
            // color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                _assignments.add('Assignment ' + _assCount.toString());
                _assCount++;
              });
            },
            child: Text('Add Assignment'),
            // color: _primaryColour,
          ),
        ),
        Assessments(_assignments),
        // ListView(
        //   padding: const EdgeInsets.all(8.0),
        //   children: <Widget>[
        //     Container(
        //       height: 50,
        //       child: Center(
        //         child: Assessments(_assignments),
        //       ),
        //     )
        //   ],
        // )
      ],
    );
  }
}
