import 'package:expenseapp/models/bargraph/bottom_tiles.dart';
import 'package:expenseapp/models/bargraph/graph_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {

final double? maxY;
final double amountSunday;
final double amountMonday;
final double amountTuesday;
final double amountWednesday;
final double amountThursday;
final double amountFriday;
final double amountSaturday;

const BarGraph({
  super.key,
  required this.maxY,
  required this.amountSunday,
  required this.amountMonday,
  required this.amountTuesday,
  required this.amountWednesday,
  required this.amountThursday,
  required this.amountFriday,
  required this.amountSaturday,
});

@override
Widget build(BuildContext context){
  
  GraphData myGraph = GraphData(
    amountMonday: amountMonday,
    amountTuesday: amountTuesday,
    amountWednesday: amountWednesday,
    amountThursday: amountThursday,
    amountFriday: amountFriday,
    amountSaturday: amountSaturday,
    amountSunday: amountSunday
    );

  myGraph.inputBarData();
  
  return BarChart(
    BarChartData(
        maxY: maxY,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles
          ))

        ),
        barGroups: myGraph.barData.map((data)=> BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(
              toY: data.y.clamp(0, maxY!),
              color: data.y > maxY! ? const Color.fromARGB(255, 238, 123, 115) : Theme.of(context).colorScheme.tertiary,
              width: 25,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Theme.of(context).colorScheme.tertiaryContainer
              )
              
              ),
              
          ]
          )).toList()

      )
    );
  }
}


