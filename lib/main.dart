import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/firebase_options.dart';
import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/pages/auth_page.dart';
import 'package:expenseapp/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true
  );

  runApp(ChangeNotifierProvider(
    create: (_)=> ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpensesData()),
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.themeData,
        home: const AuthPage(),
      ), 
    );
}
}
