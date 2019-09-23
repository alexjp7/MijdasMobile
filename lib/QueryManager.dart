//USE TO STORE API REQUESTS




import 'Pages/HomePage.dart';
import 'Pages/AssessmentPage.dart';


class QueryManager{
  static final QueryManager _queryManager = new QueryManager._internal();//singleton stuff

 // List<Universities> universityList;


  factory QueryManager(){
    return _queryManager;//singleton stuff
  }

  QueryManager._internal();//singleton stuff
}