//USE TO STORE API REQUESTS

//##################
//JOEL IDK HOW U PLAN TO USE THIS FILE SO IM CHUCKING IN 
//RANDOM API STUFF I PLAN TO USE GLOBALLY, U CAN REARRANGE HOWEVER U WANT OK -MITCH
//WILL PROBS ADD THE CALLS IN AFTER MEETING, UNLESS U DO FIRST.
//CALLS TO BE ADDED: (Referenced in API Doc) 
//          - '3.2.7 Add Student to Subject'
//          - '3.2.9  Add Tutor to Subject'
//          - '3.2.10  Toggle Assessment Activation'
//          - '3.2.11  Create Subject'
//          - '3.2.12  Create Criteria'
//##################


import './home.dart';
import './assessment.dart';


class QueryManager{
  static final QueryManager _queryManager = new QueryManager._internal();//singleton stuff

 // List<Universities> universityList;


  factory QueryManager(){
    return _queryManager;//singleton stuff
  }

  QueryManager._internal();//singleton stuff
}