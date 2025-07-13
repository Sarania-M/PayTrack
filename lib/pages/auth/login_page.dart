import 'package:expenseapp/methods/auth_service.dart';
import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/models/gradient_button.dart';
import 'package:expenseapp/models/input_field.dart';
import 'package:expenseapp/theme/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
final Function()? onTap;
const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final TextEditingController emailCont = TextEditingController();
final TextEditingController passCont = TextEditingController();
Future<void> logUserIn(
  TextEditingController emailCont,
  TextEditingController passCont,
) async {
  if (!mounted) return;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailCont.text.trim(),
      password: passCont.text.trim(),
    );

    if (!mounted) return;
    Navigator.of(context).pop();

    // ✅ FETCH user-specific data
    final provider = Provider.of<ExpensesData>(context, listen: false);
    await provider.prepare();
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
    Navigator.of(context).pop();

  if (e.code == 'user-not-found') {
  showError('No user found with that email.', context);
   } else if (e.code == 'wrong-password') {
  showError('Incorrect password.', context);
   } else if (e.code == 'invalid-credential') {
  showError('Either your email and/or your password is incorrect', context);
   } else if (e.code== 'invalid-email') {
    showError('Please enter a valid email', context);
  }
  else {
  showError('Authentication failed. Please try again.', context);
   }
  }
  }
}


void showError(String message, BuildContext context) {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        message,
        style: const TextStyle(fontFamily: 'Cera',fontSize: 18),
      ),
    ),
  );
}




  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: darkMode.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login.',style: TextStyle(fontFamily: 'Cera',fontSize: 44,color: Colors.white),),
                const SizedBox(height: 15,),
                InputField(hintText: 'Email', cont: emailCont, val: false,icon: Icon(Icons.email_rounded),),
                SizedBox(height: 15,),
                InputField(hintText: 'Password', cont: passCont, val: true,icon: Icon(Icons.lock_outline),),
                const SizedBox(height: 20,),
                GradientButton(labelText: 'Login', onTap: () => logUserIn(emailCont, passCont), color1: Color.fromARGB(198, 198, 91, 177), color2: const Color.fromARGB(255, 134, 66, 132)),
                const SizedBox(height: 15,),
                Row(children: [
                  const SizedBox(width: 14,),
                  Expanded(child: Divider(color: const Color.fromARGB(167, 255, 255, 255),thickness: 0.5,)),
                  const SizedBox(width: 10,),
                  Text('Or Continue with',style: TextStyle(fontFamily: 'Cera',color: const Color.fromARGB(167, 255, 255, 255),fontSize: 15),),
                  const SizedBox(width: 10,),
                  Expanded(child: Divider(color: const Color.fromARGB(167, 255, 255, 255),thickness: 0.5,)),
                  const SizedBox(width: 14,),
            
                ],),
                const SizedBox(height:10),
                Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(colors: [const Color.fromARGB(255, 88, 97, 102),const Color.fromARGB(212, 91, 100, 105)])
                ),
                child: ElevatedButton(onPressed: ()=> AuthService().handleGoogleLogin(context),
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                fixedSize: const Size(384, 55),
                shadowColor: const Color.fromARGB(0, 22, 20, 20),
                ), child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_rounded,color: Colors.white,),
                    
                    SizedBox(width: 7,),
                    
                    Text('Google',style: TextStyle(color: Colors.white,fontFamily: 'Cera',fontSize: 15),)
                  ],
                )),
                ),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?",style: TextStyle(fontFamily: 'Cera',fontSize: 17,color: const Color.fromARGB(167, 255, 255, 255)),),
                    const SizedBox(width: 7,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Sign Up",style: TextStyle(fontFamily: 'Cera',fontSize: 17,color: Color.fromARGB(198, 198, 91, 177)),)),
                  ],
                )              
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}

