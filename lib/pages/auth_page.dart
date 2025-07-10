import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/pages/auth/loginOrSignUp.dart';
import 'package:expenseapp/pages/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
const AuthPage({ super.key });

  @override
  Widget build(BuildContext context){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          Future.microtask(() {
            Provider.of<ExpensesData>(context, listen: false).prepare();
          });
          return MainScreen(); 
        } else {
          return LoginOrSignUp(); 
        }
      },
    );
  }
  }