import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget getBottomTitles(double value, TitleMeta meta){
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
    color: Color.fromARGB(255, 118, 111, 111)
  );
  Widget text;
  
  switch (value.toInt()) {
    case 0:
      text = Text('S',style: style,);
      break;
    case 1:
      text = Text('M',style: style,);
    case 2:
      text = Text('T',style: style,);
      break;
    case 3:
      text = Text('W',style: style,);
      break;
    case 4:
      text = Text('T',style: style,);
      break;
    case 5:
       text = Text('F',style: style,);
      break;
    case 6:
       text = Text('S',style: style,);
      break;  
      
    default:
      text = Text('');
  }

 return SideTitleWidget(meta: meta,child: text, );

}