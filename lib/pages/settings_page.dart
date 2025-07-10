import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({ super.key });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  
  double? _currentBudget;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // Initialize the current budget from the Hive box
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final provider = Provider.of<ExpensesData>(context, listen: false);
    double? fetched = await provider.getDailyBudget();
    setState(() {
      _currentBudget = fetched;
    });
  }

  void _showEditBudgetDialog() {
    final provider = Provider.of<ExpensesData>(context, listen: false);
    TextEditingController budgetController = TextEditingController();
    budgetController.text = _currentBudget?.toString() ?? '';
    

    showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('Edit Daily Budget', style: TextStyle(fontFamily: 'Cera', fontSize: 20, color: Theme.of(context).colorScheme.primaryContainer)),
      content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      TextField(
      controller: budgetController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefix: Padding(
          padding: const EdgeInsets.only(right: 5.0,top: 2),
          child: Text('₹', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryContainer)),
        ),
        hintText: 'Enter your budget',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Cera',
          color: const Color.fromARGB(134, 112, 107, 107),
        ),
      ),
    ),
  ],
),
      actions: [
        ElevatedButton(
            child: const Text("CANCEL",style: TextStyle(fontFamily: 'Cera')),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("SAVE",style: TextStyle(fontFamily: 'Cera')),
            onPressed: () async {
              final enteredBudget = double.tryParse(budgetController.text.trim());
              if (enteredBudget != null && enteredBudget > 0) {
                await provider.saveDailyBudget(enteredBudget);
                setState(() {
                  _currentBudget = enteredBudget;
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a valid number")),
                );
              }
            },
          ),
      ] 
    ));
  }
  
  void _showDeveloper(){
    showDialog(context: context, builder: (context)=>
    AlertDialog(
      title: Center(child: Text('Developer Info', style: TextStyle(fontFamily: 'Cera',fontWeight: FontWeight.w700, fontSize: 20))),
      content: const Text(
        'Developed by Madhurjya Bijoy Sarania.\n\n'
        'For any queries or feedback, please contact me at:\n\n'
        'Email: madhurjyasarania@gmail.com',
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;   

    return Consumer<ThemeProvider>(builder: (context,value,child)=>
    
    Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: Text('Settings', style: TextStyle(fontFamily: 'Cera', fontSize: 20)),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(9),
              bottomRight: Radius.circular(9),
            ),
          ),
          centerTitle: true,
          elevation: 4,
          shadowColor: const Color.fromARGB(133, 0, 0, 0),
        ),
      ),
      body:  ListView(
        
        children: [
          //Edit Daily Budget
          Container(
            margin: const EdgeInsets.only(top:30,left:10,right:10,bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: const Color.fromARGB(59, 126, 121, 121)
            ),
            child: ListTile(
              title: const Text("Daily Budget",style: TextStyle(fontFamily: 'Cera',fontSize: 18),),
              subtitle: Text(
                _currentBudget!= null
                    ? "₹${_currentBudget!.toStringAsFixed(2)}"
                    : "Not set",
                style: const TextStyle(fontFamily: 'Cera',fontSize: 12),
              ),
              trailing: const Icon(Icons.edit),
              onTap: _showEditBudgetDialog,
            ),
          ),
          
          // Dark Mode Toggle
           Container(
            margin: const EdgeInsets.only(left:10,right:10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: const Color.fromARGB(59, 126, 121, 121)
            ),
            child: ListTile(
              title: const Text("Turn on dark theme",style: TextStyle(fontFamily: 'Cera',fontSize: 17),),
              
              trailing: Switch(value: isDarkMode, onChanged: (value){
                Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
              }),
              
            ),
          ),
           
          //Signout user
          Container(
            margin: const EdgeInsets.only(top:10,left:10,right:10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: const Color.fromARGB(59, 126, 121, 121)
            ),
            child: ListTile(
              title: const Text("Sign Out",style: TextStyle(fontFamily: 'Cera',fontSize: 18),),
              subtitle: Text("Logged in as ${user.email!}",style: TextStyle(fontFamily: 'Cera'),),
              trailing: const Icon(Icons.logout_rounded),
              onTap: () => showDialog(context: context, builder: (context)=>AlertDialog(
                title: Text('Are you sure you want to sign out ?',style: TextStyle(fontFamily: 'Cera',fontSize: 17.5),),
                actions: [
                  ElevatedButton(onPressed: ()async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }, child: Text('Yes',style: TextStyle(fontFamily: 'Cera'),)),
                  ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Cancel',style: TextStyle(fontFamily: 'Cera')))
                ],
              ))),
            ),

          //About
          Container(
            margin: const EdgeInsets.only(top:10,left:10,right:10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: const Color.fromARGB(59, 126, 121, 121)
            ),
            child: ListTile(
              title: const Text("Developer's Info",style: TextStyle(fontFamily: 'Cera',fontSize: 17),),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: _showDeveloper,
            ),
          ),
          
        ],
      ),
      
    ));
  }
}