import 'package:expenseapp/methods/date_converter.dart';
import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/models/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseOverview extends StatefulWidget {

final DateTime startofWeek;
const ExpenseOverview({
  super.key,
  required this.startofWeek
  });

  @override
  State<ExpenseOverview> createState() => _ExpenseOverviewState();
}

class _ExpenseOverviewState extends State<ExpenseOverview> {
double maxY = 100;

//calculate the week's total expenses
String calculateWeekTotal(
  ExpensesData value,
  String sunday,
  String monday,
  String tuesday,
  String wednesday,
  String thursday,
  String friday,
  String saturday
){
double weekTotal = 0;

List<double> values = [
  value.calculateexpenses()[sunday] ?? 0,
  value.calculateexpenses()[monday] ?? 0,
  value.calculateexpenses()[tuesday] ?? 0,
  value.calculateexpenses()[wednesday] ?? 0,
  value.calculateexpenses()[thursday] ?? 0,
  value.calculateexpenses()[friday] ?? 0,
  value.calculateexpenses()[saturday] ?? 0,      
];

for(int i=0; i<values.length;i++){
  weekTotal += values[i];
}
return weekTotal.toStringAsFixed(2);
}

@override
  void initState() {
    super.initState();
    _loadBudget();
  }

void _loadBudget() async {
  final provider = Provider.of<ExpensesData>(context, listen: false);
  final budget = await provider.getDailyBudget();
  if (budget != null) {
      setState(() {
        maxY = budget;
      });
    }
}

@override
Widget build(BuildContext context){
    
    String sunday = converter(widget.startofWeek.add(const Duration(days: 0)));
    String monday = converter(widget.startofWeek.add(const Duration(days: 1)));
    String tuesday = converter(widget.startofWeek.add(const Duration(days: 2)));
    String wednesday = converter(widget.startofWeek.add(const Duration(days: 3)));
    String thursday = converter(widget.startofWeek.add(const Duration(days: 4)));
    String friday = converter(widget.startofWeek.add(const Duration(days: 5)));
    String saturday = converter(widget.startofWeek.add(const Duration(days: 6)));

    
    return Consumer<ExpensesData>(
      builder: (context,value,child) => Column(
        children: [
          //weeks total spend
          Padding(
             padding: const EdgeInsets.only(left: 25,top: 15,bottom: 15,
              right: 10),
            child: Row(children: [
              const Text('This week:  ',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,fontFamily: 'Cera'),),
              
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text('₹${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                style: TextStyle(fontSize: 20,fontFamily: 'Cera',),),
              )
            ],),
          ),
          
          
          //bar graph for expenses
          SizedBox(
            height: 200,
            child: BarGraph
            (maxY: maxY, //height og bar graph by deafult 100
            amountSunday: value.calculateexpenses()[sunday]?? 0,
            amountMonday: value.calculateexpenses()[monday]?? 0, 
            amountTuesday: value.calculateexpenses()[tuesday]?? 0, 
            amountWednesday: value.calculateexpenses()[wednesday]?? 0, 
            amountThursday: value.calculateexpenses()[thursday]?? 0, 
            amountFriday: value.calculateexpenses()[friday]?? 0, 
            amountSaturday: value.calculateexpenses()[saturday]?? 0)
            
          ),
        ],
      )
      
    ) ;
  }
}