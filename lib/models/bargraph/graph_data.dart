import 'package:expenseapp/models/bargraph/each_bar.dart';

class GraphData {
  final double amountSunday;
  final double amountMonday;
  final double amountTuesday;
  final double amountWednesday;
  final double amountThursday;
  final double amountFriday;
  final double amountSaturday;

  GraphData({
    required this.amountSunday,
    required this.amountMonday,
    required this.amountTuesday,
    required this.amountWednesday,
    required this.amountThursday,
    required this.amountFriday,
    required this.amountSaturday,
  });

  List<EachBar> barData=[];
  
  void inputBarData(){
    barData = [
      EachBar(x: 0, y: amountSunday),
      EachBar(x: 1, y: amountMonday),
      EachBar(x: 2, y: amountTuesday),
      EachBar(x: 3, y: amountWednesday),
      EachBar(x: 4, y: amountThursday),
      EachBar(x: 5, y: amountFriday),
      EachBar(x: 6, y: amountSaturday),
      
    ];
  }
  

}