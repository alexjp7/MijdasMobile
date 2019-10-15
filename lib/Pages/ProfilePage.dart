/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/
import 'package:MarkIt/Models/QueryManager.dart';
import 'package:flutter/material.dart';

//import 'package:pie_chart/pie_chart.dart';

//local imports
import 'signin.dart';
import '../Widgets/global_widgets.dart';

class ProfilePage extends StatefulWidget{

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//TODO VVVVVVVV make this take data from the singleton and load user profile info
class _ProfilePageState extends State<ProfilePage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController_2 = TextEditingController();

  @override
  void initState(){
    super.initState();
    usernameController.text=QueryManager().loggedInUser;//stored in singleton
    emailController.text= QueryManager().loggedInEmail;
  }


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
              Navigator.pop(context);
              print("Back Arrow Clicked");
            },
          ),
        ),
        title: Text('Profile'),
        centerTitle: true,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Username",
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(color: Colors.white70)),
              ),
              controller: usernameController,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                labelText: "Email",
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(color: Colors.white70)),
              ),
              controller: emailController,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Current Password",
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(color: Colors.white70)),
              ),
              controller: passwordController,
              obscureText: true,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: "New Password",
                labelStyle: TextStyle(fontSize: 12),
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(color: Colors.white70)),
              ),
              controller: passwordController_2,
              obscureText: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: ButtonTheme(
                    minWidth: 130.0,
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                      },
                      child: RichText(
                        text: TextSpan(
                          text: ("Submit"),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      //color: _buttonColour,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(7.0)),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
