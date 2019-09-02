//Got lost trying to figure multi pages out - will need it explained after/before meeting pls xoxo - this code is ready for posts - joel


import 'package:flutter/material.dart';

void main(){
  runApp(CriteriaPage(
      items: List<Criteria>.generate(10, (i) => new Criteria("Criterea $i",i,i%3,(((i%3)*5)+5),1.0)
      )));
}



class CriteriaPage extends StatefulWidget{
  final List<Criteria> items;
  CriteriaPage({Key key, @required this.items}) : super(key:key);

  @override
  _CriteriaPageState createState() => _CriteriaPageState(this.items);
}


class _CriteriaPageState extends State<CriteriaPage>{
  final List<Criteria> items;
  _CriteriaPageState(this.items);

  Widget _buildSliders(int index){
    if(items[index].elementType==0){
      return Flexible(
          flex:1,
          child: Slider(

            min: 0.0,
            max:items[index].maxMark.toDouble(),
            onChanged: (newSliderValue) {
              setState(() => items[index].value = newSliderValue.roundToDouble());
            },
            value: items[index].value,
          )
      );
    }
    else if(items[index].elementType==1){
      return Flexible(
          flex:1,
          child: Checkbox(
              value: true,
              onChanged: (newCheckBoxValue) {
                setState(()=> items[index].value = 10.0);
              }
          )
      );
    }
    else{
      return Flexible(
          flex:1,
          child: TextField(
            // Text:items[index].value,

          )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    final title = 'criteria prototype';


    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Column(
                    children:
                    <Widget>[Text('${items[index].name}'),
                      Text('${items[index].value}'+'/'),
                      Text('${items[index].maxMark}'),]
                ),

                subtitle: Row(
                    children:
                    <Widget>[_buildSliders(index),

                    ])

            );
          },
        ),
      ),
    );
  }
}

class Criteria{
  String name;
  int iD,elementType,maxMark;
  double value;
  Criteria(this.name, this.iD, this.elementType, this.maxMark,this.value);
}
