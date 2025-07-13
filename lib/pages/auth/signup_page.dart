import 'package:expenseapp/methods/auth_service.dart';
import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/models/gradient_button.dart';
import 'package:expenseapp/models/input_field.dart';
import 'package:expenseapp/theme/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {

SignupPage({ super.key , required this.onTap });
  final Function()? onTap;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
final TextEditingController emailCont = TextEditingController();

final TextEditingController passCont = TextEditingController();

final TextEditingController confirmPass = TextEditingController();

Future<void> registerUser(
  TextEditingController emailCont,
  TextEditingController passCont,
  TextEditingController confirmPass,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    if (passCont.text == confirmPass.text) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCont.text.trim(),
        password: passCont.text.trim(),
      );

      if (context.mounted) {
        final provider = Provider.of<ExpensesData>(context, listen: false);
        await provider.prepare();
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
        showError('Passwords don\'t match', context);
        return;
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();

      if (e.code == 'email-already-in-use') {
        showError('Email already in use', context);
      } else if (e.code == 'invalid-email') {
        showError('Invalid email', context);
      } else if (e.code == 'weak-password') {
        showError('Weak password', context);
      } else {
        showError(e.message ?? 'Unknown error', context);
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
                Text('Sign Up.',style: TextStyle(fontFamily: 'Cera',fontSize: 44,color: Colors.white),),
                const SizedBox(height: 15,),
                InputField(hintText: 'Email', cont: emailCont, val: false,icon: Icon(Icons.email),),
                const SizedBox(height: 15,),
                InputField(hintText: 'Password', cont: passCont, val: true,icon: Icon(Icons.lock_outline),),
                const SizedBox(height: 15,),
                InputField(hintText: 'Confirm password', cont: confirmPass, val: true,icon: Icon(Icons.lock_outline),),
                const SizedBox(height: 20,),
                GradientButton(labelText: 'Login', onTap: () => registerUser(emailCont, passCont, confirmPass),color1:Color.fromARGB(198, 198, 91, 177),color2:const Color.fromARGB(255, 134, 66, 132)),
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
                    Text("Already a user?",style: TextStyle(fontFamily: 'Cera',fontSize: 17,color: const Color.fromARGB(167, 255, 255, 255)),),
                    const SizedBox(width: 7,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Log In",style: TextStyle(fontFamily: 'Cera',fontSize: 17,color: Color.fromARGB(198, 198, 91, 177)),)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}