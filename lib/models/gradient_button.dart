import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget{
  final String labelText;
  final Function()? onTap;
  final Color color1;
  final Color color2;
  
  const GradientButton({
    super.key,
    required this.labelText,
    required this.onTap,
    required this.color1,
    required this.color2
  });
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(colors: [color1,color2])
      ),
      child: ElevatedButton(onPressed: onTap,
        style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        fixedSize: const Size(384, 55),
        shadowColor: const Color.fromARGB(0, 22, 20, 20),
      ), child: Text(labelText,style: TextStyle(color: Colors.white,fontFamily: 'Cera',fontSize: 15),)),
    );
  }
}