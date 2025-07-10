
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemTile extends StatelessWidget {
final String name;
final double amount;
final DateTime dateTime;
final String category;
void Function(BuildContext)? deleteTapped;

ItemTile({
  super.key,
  required this.name,
  required this.amount,
  required this.dateTime,
  required this.category,
  required this.deleteTapped
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: Slidable(
        
          endActionPane: ActionPane(motion: StretchMotion(), children: [
            SizedBox(width: 5,),
          //delete button
          SlidableAction(
            autoClose: true,
            onPressed: deleteTapped,
            icon: Icons.delete,
            foregroundColor: Colors.white70,
            backgroundColor: const Color.fromARGB(255, 188, 111, 106),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ]),
        child: Container(
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Theme.of(context).colorScheme.surfaceContainer
          ),
          
          child: ListTile(
                title: Text(name,style: TextStyle(fontFamily: 'Cera',fontWeight: FontWeight.w700,fontSize: 18),),
                subtitle: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}    $category',style: TextStyle(fontFamily: 'Cera'),),
                trailing: Text('₹$amount',style: TextStyle(fontFamily: 'Cera',fontWeight: FontWeight.w700,fontSize: 18),),
                ),
        ),
      ),
    );
  }
}