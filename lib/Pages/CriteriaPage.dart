/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
/*
TODO----------
-add slider incerements --Done(-Mitch)
-fix http --?(-Mitch)
-add submit button --Done(-Mitch)
-make it so when you go back it resets the students(so marks get updated)


 */
import 'package:flutter/material.dart';
import '../Widgets/global_widgets.dart';

//local imports
import 'signin.dart';
import 'StudentsPage.dart';

import '../Models/Criterion.dart';
//import '../Models/CriteriaDecode.dart';
import '../Models/Student.dart';

import '../Functions/submits.dart';


//data handling/processing imports

Student _selectedStudent;
BuildContext _critContext;
// Color _buttonColour = new Color(0xff0069C0);
Color _activeColour = new Color(0xff0069C0);
Color _inactiveColour = new Color(0xffA0C8E3);
List<Criterion> _assCrit;
List<Criterion> _items;
String _assID;
//bool _isFetchDone; //boolean check to see if API request is finished before populating certain fields



class CriteriaPageState extends StatefulWidget {
  //List<Criterion> items = List<Criterion>.generate(10, (i) => new Criterion("Criterea $i",i,i%3,(((i%3)*5)+5),1.0));
  CriteriaPageState(s,assID,criteria){
    _selectedStudent = s; //assigning page ID
    _assID = assID;
    _assCrit = criteria;
  }

  @override
  CriteriaPage createState() => CriteriaPage();
}

class CriteriaPage extends State<CriteriaPageState> {
  Color _accentColour = Color(0xffBFD4DF);

  CriteriaPage() {
    _items = _assCrit;
  }

  /*
    element cheat sheet: (Element ID - Object Type)
    
    0 - Checkbox
    1 - Slider
    2 - Textfield
    3 - CommentBox
  
  */
  Widget _buildTiles(int index) {
    if (_items[index].element == "0") {
      return Flexible(
          flex: 1,
          child: Center(
              child: Checkbox(
                  value: _items[index].isChecked(),
                  activeColor: _activeColour,
                  onChanged: (val) {
                    setState(() {
                      _items[index].makeChecked(val);
                      _items[index].isChecked()
                          ? _items[index].value = _items[index].maxMarkI
                          : _items[index].value = 0;
                    });
                  })));
    } else if (_items[index].element == "1") {
      //items[index].value = 0;
      return Flexible(
          flex: 1,
          child: SliderTheme(
            data: SliderThemeData(
              //for concealing track ticks lol
              thumbColor: _activeColour,
              activeTrackColor: _activeColour,
              activeTickMarkColor: _activeColour,
              inactiveTrackColor: _inactiveColour,
              inactiveTickMarkColor: _inactiveColour,
              overlayColor: _activeColour.withAlpha(32),
            ),
            child: Slider(
              min: 0.0,
              max: _items[index].maxMarkI,
              divisions: _items[index].maxMarkI.toInt() * 4,
              //creates increments of 0.25
              onChanged: (newSliderValue) {
                setState(() {
                  _items[index].value = newSliderValue;
                  // items[index].value = double.parse(newSliderValue.toStringAsPrecision(3));
                  // items[index].value = newSliderValue.roundToDouble();
                });
              },
              value: _items[index].value,
            ),
          ));
    } else if (_items[index].element == "2") {
      return Flexible(

          flex: 10,
          child: Padding(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
              child:Row(

            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Flexible(
            flex: 1,
                child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _items[index].tControl,

                    //textAlign: TextAlign.right, //what a stupid bug this is
                    onChanged: (text) {
                      if (isNumeric(text)) {
                        double _enteredMark = double.parse(text);
                        if (_enteredMark >= _items[index].maxMarkI) {
                          _items[index].value = _items[index].maxMarkI;
                        }
                        else
                          _items[index].value = _enteredMark;
                        print(text);
                      }
                    },
                    onSubmitted :(text){
                      if (isNumeric(text)){
                        double _enteredMark = double.parse(text);
                        if(_enteredMark>=_items[index].maxMarkI) {
                          _items[index].tControl.text = _items[index].maxMark;
                        }
                        print(text);
                        }
                    },

    )),
    Expanded(child: Text('/${_items[index].maxMark}')),
    ])));
    } else
    return Flexible(child
    :
    TextField
    (
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
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
          title: Text('Marking'),
          centerTitle: true,
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.dehaze),
          //     onPressed: () {
          //       Navigator.push(context, homeRoute());
          //       print("Hamburger Menu Clicked");
          //     },
          //   )
          // ],
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
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                width: 500,
                height: 50,
                child: _markingTitleArea(),
              ),
              Flexible(
                  flex: 10,
                  child: ListView.builder(
                      itemCount: (_items.length-1),
                      itemBuilder: (context, index) {

                        String criteriaValueText;
                        index++;

                       // if (_items[index].maxMark == null) return null;//if its the overall comment then ignore it

                        criteriaValueText = '${_items[index].value}' +
                              '/' +
                              '${_items[index].maxMark}';

                        _critContext = context;

                        return ListTile(
                          dense: true,
                          enabled: true,
                          isThreeLine: false,
                          title: new Card(
                            //MAKE BUILD CARDS
                              color: _accentColour,
                              child: Center(
                                  child: Column(children: <Widget>[
                                    Text(
                                      '${_items[index].displayText}',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Text(
                                      criteriaValueText,
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    Row(children: <Widget>[
                                      _buildTiles(index),
                                    ]),
                                  ]))),
                        );
                      })),
              //   new Container(height: 20, alignment:Alignment.bottomLeft,child: Text('Comments:')),//MAYBE CHANGE THIS TO A labelText???????
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 175.0,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      child: new Scrollbar(
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextField(
                                controller: _items[0].tControl,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  //hintText: "Comments",
                                  labelText: "Comments",
                                  fillColor: Colors.white70,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(20.0),
                                ),
                                onChanged: (s){
                                  _items[0].comment=_items[0].tControl.text;
                                  print(_items[0].comment);
                                },
                              ))))),
              Container(
                width: 500,
                height: 70,
                child: _markingFooterArea(),
              ),
            ]));
  }
}

Widget _markingTitleArea() {
  Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue
  // _isFetchDone = false;
  _mainBackdrop = isMarkedCol(getStudent());

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500,
        //415 for width of pixel
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(color: _mainBackdrop),
            Positioned(
              top: 15,
              left: 30,
              width: 330,
              height: 30,
              child: RichText(
                text: TextSpan(
                    text: ("Username:    "),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: getStudent(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 5,
        left: 330,
        width: 80,
        height: 40,
        child: Text(""),
      ),
    ],
  );
}

Widget _markingFooterArea() {
  Color _mainBackdrop = new Color(0xffE1E2E1); //canvas colour
  // Color _mainBackdrop = new Color(0xff54b3ff); //lighter blue
  // Color _mainBackdrop = new Color(0xff2196F3); //light blue
  // _isFetchDone = false;

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        width: 500,
        //415 for width of pixel
        height: 70,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(color: _mainBackdrop),
            Positioned(
              top: 5,
              left: 60,
              width: 150,
              height: 30,
              child: RichText(
                text: TextSpan(
                  text: ("Marks:"),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 25,
        left: 80,
        width: 120,
        //should run to about the middle
        height: 40,
        child: RichText(
          text: TextSpan(
              text: (getTotalGivenMark().toString()),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: ("/" + getMaximumMark().toString()),
                    style: TextStyle(
                        color: Colors.grey[700], fontWeight: FontWeight.w600))
              ]),
        ),
      ),
      Positioned(
        top: 0,
        left: 210,
        width: 170,
        height: 60,
        child: Container(
          child: ButtonTheme(
            minWidth: 170.0,
            height: 60.0,
            child: RaisedButton(
              onPressed: () async {
                print("Submit Button pressed.");
                postMark(_items,_selectedStudent.studentId,_assID,_critContext);
              },
              child: RichText(
                text: TextSpan(
                  text: ("Submit"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              color: _activeColour,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(7.0)),
              textColor: Colors.white,
            ),
          ),
        ),

        /*RichText(
          text: TextSpan(
            text: ("7.5/10"),
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),*/
      ),
    ],
  );
}

double getMaximumMark() {
  var max = 0.00;
  try {
    _assCrit.forEach((x) {
      if (x.maxMark != null) max += x.maxMarkI;
    });
  } catch (e) {
    return -1;
  }
  return max;
}

double getTotalGivenMark() {
  var count = 0.00;
  try {
    _assCrit.forEach((x) {
      if (x.value != null) count += x.value;
    });
  } catch (e) {
    return -1;
  }
  return count;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s) != null;
}

