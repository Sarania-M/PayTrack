import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseItem {
  String? id;
  String uid;
  final String name;
  final double amount;
  final DateTime dateTime;
  final String category;

  ExpenseItem({
    this.id,
    required this.uid,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.category
  });

  factory ExpenseItem.fromMap(Map<String, dynamic> map, String docId) {
    return ExpenseItem(
      id: docId,
      uid: map['uid'],
      name: map['name'],
      amount: (map['amount'] as num).toDouble(),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap(String uid) {
    return {
      'uid': uid,
      'name': name,
      'amount': amount,
      'dateTime': dateTime,
      'category': category,
    };
  }

}