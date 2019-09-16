//USE TO STORE API REQUESTS

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