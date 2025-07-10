import 'package:flutter/material.dart';

class InputField extends StatelessWidget{
final String hintText;
final bool val;
final TextEditingController cont;
final Icon icon ;

const InputField({
  required this.hintText,
  required this.cont,
  required this.val,
  required this.icon,
  super.key
});

@override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 384,
      child: TextFormField(
        style: TextStyle(fontFamily: 'Cera',color: const Color.fromARGB(192, 255, 255, 255)),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon,
          prefixIconColor: const Color.fromARGB(134, 112, 107, 107) ,
          hintStyle: TextStyle(color: const Color.fromARGB(134, 112, 107, 107),fontFamily: 'Cera'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 147, 166, 168),
                      width: 2.0,
                    )
                  )
        ),
        obscureText: val,
        controller: cont,
      ),
    );
  }


}