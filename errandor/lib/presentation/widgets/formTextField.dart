// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget formTextField(
   {required TextEditingController controller,
    hint = "",
    labelText = "",
    IconData icon = Icons.abc,
    bool isPassword = false, required String? Function(dynamic value) validator}
){
  return TextField(
    obscureText: isPassword,
    controller: controller,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: hint,
      labelText: labelText,
      labelStyle: TextStyle(
        color:  Colors.grey.withOpacity(0.6)
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF242424))
      ),
       focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black)
      ),
      prefixIcon: Icon(icon),
      suffixIcon: isPassword ? Icon(Icons.visibility) : null,
    ),
  );
}
