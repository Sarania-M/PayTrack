import 'package:expenseapp/pages/auth/login_page.dart';
import 'package:expenseapp/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';

class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({ super.key });

  @override
  _LoginOrSignUpState createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool showLogin = true;

  void togglePages(){
    setState(() {
      showLogin = !showLogin ;
    });
  }

  @override
  Widget build(BuildContext context) {
   if(showLogin){
    return LoginPage(
      onTap: togglePages,
    );
   }

   else{
    return SignupPage(
      onTap: togglePages,
    );
   }
  }
}