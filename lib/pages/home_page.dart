import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/models/expense_item.dart';
import 'package:expenseapp/models/expense_overview.dart';
import 'package:expenseapp/models/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  
  //controllers for the text fields
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ExpensesData>(context, listen: false).prepare();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkAndPromptBudget();
  });
  }
  
  //check if the daily budget is set, if not prompt the user to set it
  void _checkAndPromptBudget() async {
  final provider = Provider.of<ExpensesData>(context, listen: false);
  final budget = await provider.getDailyBudget();

  if (budget == null) {
    _showBudgetDialog(provider);
  }
}

 //show a dialog to set the daily budget
 void _showBudgetDialog(ExpensesData provider) {
  TextEditingController budgetCont = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        iconPadding: const EdgeInsets.only(top: 10, left: 7),
        title: Text(
          'Set your daily budget',
          style: TextStyle(
            fontFamily: 'Cera',
            fontSize: 20,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        content: TextField(
          controller: budgetCont,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.currency_rupee,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            hintText: 'TYPE',
            hintStyle: const TextStyle(
              color: Color.fromARGB(134, 112, 107, 107),
              fontFamily: 'Cera',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 147, 166, 168),
                width: 2.0,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final entered = double.tryParse(budgetCont.text);
              if (entered != null && entered > 0) {
                await provider.saveDailyBudget(entered); // 🔁 now using Firestore
              }
              
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text(
              'SAVE',
              style: TextStyle(fontFamily: 'Cera'),
            ),
          ),
        ],
      );
    },
  );
}


  //save a new expense
 void save(String selectedCategory){
  final provider = Provider.of<ExpensesData>(context, listen: false);

  if (nameController.text.isNotEmpty && amountController.text.isNotEmpty && selectedCategory.isNotEmpty){
    ExpenseItem newItem = ExpenseItem(
      uid: '', // will be set inside addExpense
      name: nameController.text,
      amount: double.parse(amountController.text),
      dateTime: DateTime.now(),
      category: selectedCategory,
    );

    provider.addExpense(newItem).then((_) {
      // after adding expense
      provider.prepare().then((_) {
        _checkBudgetExceeded(context, provider);
      });
    });
  }

  Navigator.pop(context);
  nameController.clear();
  amountController.clear();
}


  
  //check if budget exceeded

  Future<void> _checkBudgetExceeded(BuildContext context, ExpensesData provider) async {
  final double? budget = await provider.getDailyBudget(); // 🔁 fetch from Firestore

  if (budget == null || budget <= 0) return;

  final double todayExpense = provider.getDailyExpense(); 
  final double usage = todayExpense / budget;

  if (usage >= 0.8 && usage < 1.0) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Budget Warning',
          style: TextStyle(fontFamily: 'Cera', fontWeight: FontWeight.w700),
        ),
        content: Text(
          "You've used ${(usage * 100).toStringAsFixed(2)}% of your daily budget.",
          style: const TextStyle(fontFamily: 'Cera'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK", style: TextStyle(fontFamily: 'Cera')),
          )
        ],
      ),
    );
  }

  if (todayExpense > budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Budget Exceeded',
          style: TextStyle(fontFamily: 'Cera', fontWeight: FontWeight.w700),
        ),
        content: Text(
          "You've spent ₹${todayExpense.toStringAsFixed(2)}, which exceeds your daily budget of ₹${budget.toStringAsFixed(2)}.",
          style: const TextStyle(fontFamily: 'Cera'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK", style: TextStyle(fontFamily: 'Cera')),
          )
        ],
      ),
    );
  }
}


  //cancel the dialog and clear the text fields
  void cancel(){
  Navigator.pop(context);
  nameController.clear();
  amountController.clear();
  }
  
  //show a dialog to add a new expense
  void addNewExpense(){

    String? selectedCategory;
    List<String> categories = ['Food','Transport','Shopping','Bills','Other'];
    
 
    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (context,setState)=> AlertDialog(
      title: Text('Add new expense'),
      titleTextStyle: TextStyle(fontFamily: 'Cera',fontSize: 20,color: Theme.of(context).colorScheme.primaryContainer),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Item name', 
                hintStyle: TextStyle(color: const Color.fromARGB(134, 112, 107, 107),fontFamily: 'Cera'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 147, 166, 168),
                    width: 2.0,
                  )
                )
              ),
              keyboardType: TextInputType.name,
             
            ),
         
          SizedBox(height: 10,),

          
          TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Price',
                prefixIcon: Icon(Icons.currency_rupee,size:20,),
                hintStyle: TextStyle(color: const Color.fromARGB(134, 112, 107, 107),fontFamily: 'Cera'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 147, 166, 168),
                    width: 2.0,
                  )
                )
              ),
              keyboardType: TextInputType.numberWithOptions(),
            ),
        
          SizedBox(height: 10,),
          DropdownButton(
          value: selectedCategory,
          hint: Text('Select Category',style: TextStyle(fontFamily: 'Cera'),),
          isExpanded: true,
          items: categories.map((String category){
            return DropdownMenuItem<String>(value: category,child: Text(category,style: TextStyle(fontFamily: 'Cera'),),);
          }).toList(),
          onChanged: (newValue){
            setState((){
              selectedCategory = newValue;
            });
          },
          )
        ],
      
      ),
      actions: [
        ElevatedButton(onPressed: () {
    if (selectedCategory != null) {
      save(selectedCategory!); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
       );
     }
    }, 
    child: Text('ADD', style: TextStyle(fontFamily: 'Cera'),)),
        
    //cancel button
    ElevatedButton(onPressed: cancel, child: Text('CANCEL',style: TextStyle(fontFamily: 'Cera'),))
      
      ],
    ));
    });
}
  
  //delete a expense
  void deleteExpense(ExpenseItem item){
    Provider.of<ExpensesData>(context, listen: false).removeExpense(item);
  }

  
  @override
  Widget build(BuildContext context) {

    
    return Consumer<ExpensesData>(builder: (context, value , child) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,

    floatingActionButton: FloatingActionButton(onPressed: (){
          addNewExpense();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 1,
        child: Icon(Icons.add,color: Theme.of(context).colorScheme.secondary,),
        ),
      
    body: 
    ListView(
        children: [
          ExpenseOverview(startofWeek: value.firstDayofWeek()),

          const SizedBox(height: 27,),
          
          ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: value.getAllExpenses().length,
          itemBuilder: (context, index)=> ItemTile(
            category: value.getAllExpenses()[index].category,
            name: value.getAllExpenses()[index].name, 
            amount: value.getAllExpenses()[index].amount, 
            dateTime: value.getAllExpenses()[index].dateTime,
            deleteTapped: (p0) => deleteExpense(value.getAllExpenses()[index]),
            ),)],
        ),
      ));
    
  }
}