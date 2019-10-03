/*
Authors: Joel
Date: 3/10/19
Group: Mijdas(kw01)
Purpose: Caching
*/



import './Models/CriteriaDecode.dart';

//import './Models/Assessment.dart';
//import './Models/Subject.dart';
//import './Models/University.dart';


class QueryManager{
  static final QueryManager _queryManager = new QueryManager._internal();//singleton stuff

 // List<Universities> universityList;
  List<CriteriaDecode> criteriaList;


  factory QueryManager(){
    return _queryManager;//singleton stuff
  }

  QueryManager._internal();//singleton stuff
}