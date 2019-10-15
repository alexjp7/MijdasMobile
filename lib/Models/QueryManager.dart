/*
Authors: Joel
Date: 3/10/19
Group: Mijdas(kw01)
Purpose: Caching
*/



import 'package:MarkIt/Models/Assessment.dart';
import 'package:MarkIt/Models/Criterion.dart';

import 'CriteriaDecode.dart';

//import './Models/Assessment.dart';
//import './Models/Subject.dart';
//import './Models/University.dart';


class QueryManager{
  static final QueryManager _queryManager = new QueryManager._internal();//singleton stuff

 // List<Universities> universityList;
  bool isCoordinator,isCoordinatorView;
  List<CriteriaDecode> criteriaList;
  List<Assessment> assessmentList;
  String loggedInUser, loggedInEmail;


  factory QueryManager(){

    return _queryManager;//singleton stuff
  }

  QueryManager._internal();//singleton stuff


  void refreshUserData(){
    //fetch profile data

  }

//  void clearCriteriaListList(){
//    criteriaListList.clear();
//  }
//
//  void addCriteriaList(List<CriteriaDecode> crit){
//    criteriaListList.add(crit);
//  }

}