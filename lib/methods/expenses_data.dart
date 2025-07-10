import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/methods/date_converter.dart';
import 'package:expenseapp/models/expense_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensesData extends ChangeNotifier{

  double? _dailyBudget;
  double get dailyBudget => _dailyBudget ?? 100.0;
  
  List<ExpenseItem> allExpenseList = [];

  //fetch expenses from firestore

  Future<void> prepare() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .where('uid', isEqualTo: uid)
        .orderBy('dateTime', descending: true)
        .get();

    allExpenseList = snapshot.docs.map((doc) {
      final data = doc.data();
      return ExpenseItem(
        id: doc.id,
        uid: data['uid'], 
        name: data['name'],
        amount: data['amount'],
        category: data['category'],
        dateTime: (data['dateTime'] as Timestamp).toDate(),
      );
    }).toList();

    await getDailyBudget();  
    notifyListeners();
  }

  Future<void> addExpense(ExpenseItem newItem) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('expenses').add({
      'uid': uid,
      'name': newItem.name,
      'amount': newItem.amount,
      'category': newItem.category,
      'dateTime': newItem.dateTime,
    });

    final itemWithId = ExpenseItem(
    id: doc.id,
    uid: uid,
    name: newItem.name,
    amount: newItem.amount,
    category: newItem.category,
    dateTime: newItem.dateTime,
  );

    allExpenseList.insert(0, itemWithId); // add to top
    notifyListeners();
  }

  Future<void> removeExpense(ExpenseItem removeItem) async {
    if (removeItem.id != null) {
      await FirebaseFirestore.instance.collection('expenses').doc(removeItem.id).delete();
    }

    allExpenseList.removeWhere((item) => item.id == removeItem.id);
    notifyListeners();
  }
  
  
  //getting the daily expenses
  double getDailyExpense() {
    final DateTime today = DateTime.now();
    double todayExpense = 0.0;

    for (var expense in allExpenseList) {
      if (_isSameDay(expense.dateTime, today)) {
        todayExpense += expense.amount;
      }
    }

    return todayExpense;
  }

  //saving budget to database
  Future<void> saveDailyBudget(double budget) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'dailyBudget': budget,
  }, SetOptions(merge: true));

  _dailyBudget = budget;
  notifyListeners();
}
  
  Future<double?> getDailyBudget() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;

  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (doc.exists && doc.data()!.containsKey('dailyBudget')) {
    _dailyBudget = (doc.data()!['dailyBudget'] as num).toDouble();
    notifyListeners();
     return _dailyBudget;
  }

  return null;
}

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  
  
  List<ExpenseItem> getAllExpenses() {
    return allExpenseList;
  }

  String getDayName(DateTime dateTime){
  switch (dateTime.weekday) {
    case 1:
        return 'Monday';
    case 2:
        return 'Tuesday';
    case 3:
        return 'Wednesday';
    case 4:
        return 'Thursday';
    case 5:
        return 'Friday';
    case 6:
        return 'Saturday';
    case 7:
        return 'Sunday';
    
    default:
      return '';
  }
}

DateTime firstDayofWeek() {
  DateTime? firstDayofWeek;

  DateTime today  = DateTime.now();

  for(int i=0; i<7 ; i++)
  {
    if(getDayName(today.subtract(Duration(days: i)))=='Sunday'){

      firstDayofWeek = today.subtract(Duration(days: i));

    }
  }
  return firstDayofWeek!;
}

Map<String , double>  calculateexpenses() {
Map<String , double> dailyExpenses = {};

for(var expense in allExpenseList){
    String date = converter(expense.dateTime);
    double amount = expense.amount;

    if(dailyExpenses.containsKey(date)){
      double currentExpense = dailyExpenses[date]!;
      currentExpense += amount;
      dailyExpenses[date] = currentExpense;
    }

    else{
      dailyExpenses.addAll({date: amount});
    }

}

return dailyExpenses;
}

}


