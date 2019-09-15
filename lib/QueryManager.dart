//USE TO STORE API REQUESTS





class QueryManager{
  static final QueryManager _queryManager = new QueryManager._internal();//singleton stuff




  factory QueryManager(){
    return _queryManager;//singleton stuff
  }

  QueryManager._internal();//singleton stuff
}